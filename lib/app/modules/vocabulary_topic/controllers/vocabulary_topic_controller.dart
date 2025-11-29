import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../core/theme/app_colors.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/example_sentence_service.dart';
import '../../../data/services/vocabulary_service.dart';
import '../../vocabulary_flashcard/bindings/vocabulary_flashcard_binding.dart';
import '../../vocabulary_flashcard/views/vocabulary_flashcard_view.dart';

class VocabularyTopicItem {
  VocabularyTopicItem({
    required this.word,
    required this.ipa,
    required this.translation,
    required this.exampleEn,
    required this.exampleVi,
    required this.status,
  });

  final String word;
  final String ipa;
  final String translation;
  final String exampleEn;
  final String exampleVi;
  final VocabularyLearningStatus status;
}

enum VocabularyLearningStatus {
  notStarted,
  learning,
  learned,
}

class VocabularyTopicArguments {
  VocabularyTopicArguments({
    required this.topicName,
    required this.items,
  });

  final String topicName;
  final List<VocabularyTopicItem> items;
}

class VocabularyTopicController extends GetxController {
  late final String topicName;
  final RxList<VocabularyTopicItem> items = <VocabularyTopicItem>[].obs;
  final FlutterTts _tts = FlutterTts();
  bool _isSavingWord = false;

  @override
  void onInit() {
    super.onInit();
    _initTts();
    final args = Get.arguments as VocabularyTopicArguments?;
    if (args != null) {
      topicName = args.topicName;
      items.assignAll(args.items);
    } else {
      topicName = 'Động vật';
      items.assignAll(VocabularyTopicController.defaultAnimalVocabulary());
    }
  }

  @override
  void onClose() {
    _tts.stop();
    super.onClose();
  }

  Future<void> playAudio(VocabularyTopicItem item) async {
    final text = item.word.trim();
    if (text.isEmpty) return;
    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (_) {
      Get.snackbar(
        'Phát âm',
        'Không thể phát âm, vui lòng thử lại.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    }
  }

  Future<void> _initTts() async {
    try {
      final languages = await _tts.getLanguages;
      if (languages != null && languages.contains('en-US')) {
        await _tts.setLanguage('en-US');
      }
      await _tts.setPitch(1.0);
      await _tts.setSpeechRate(0.45);
      await _tts.setVolume(1.0);
    } catch (_) {
      // bỏ qua lỗi khởi tạo TTS
    }
  }

  void onFlashcardPressed() {
    if (items.isEmpty) {
      Get.snackbar(
        'Flashcard',
        'Chưa có thẻ từ vựng để ôn tập.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
      return;
    }

    Get.to(
      () => const VocabularyFlashcardView(),
      binding: VocabularyFlashcardBinding(),
      arguments: {
        'items': items.toList(),
        'topicName': topicName,
      },
    );
  }

  void onAddVocabularyPressed() {
    final enController = TextEditingController();
    final viController = TextEditingController();
    Get.bottomSheet(
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDEE6EE),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Thêm từ vựng',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: enController,
                decoration: const InputDecoration(
                  labelText: 'Từ vựng Tiếng Anh',
                  hintText: 'Nhập từ vựng',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: viController,
                decoration: const InputDecoration(
                  labelText: 'Nghĩa Tiếng Việt',
                  hintText: 'Nhập nghĩa',
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final en = enController.text.trim();
                    final vi = viController.text.trim();
                    if (en.isEmpty || vi.isEmpty) {
                      Get.snackbar('Thiếu thông tin', 'Vui lòng nhập đủ từ và nghĩa');
                      return;
                    }
                    if (_isSavingWord) return;
                    FocusManager.instance.primaryFocus?.unfocus();
                    _isSavingWord = true;
                    Get.dialog(
                      const Center(child: CircularProgressIndicator()),
                      barrierDismissible: false,
                    );
                    try {
                      final details = await _fetchWordDetails(en, vi);
                      final item = VocabularyTopicItem(
                        word: en,
                        ipa: details.ipa,
                        translation: vi,
                        exampleEn: details.exampleEn,
                        exampleVi: details.exampleVi,
                        status: VocabularyLearningStatus.notStarted,
                      );
                      await _persistWord(item);
                      items.add(item);
                      items.refresh();
                      Get.back(); // close loading
                      Get.back(); // close bottom sheet
                      Get.snackbar('Thành công', 'Đã thêm từ vào chủ đề "$topicName"');
                    } catch (e) {
                      Get.back(); // close loading
                      Get.snackbar(
                        'Lỗi',
                        e.toString(),
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    } finally {
                      _isSavingWord = false;
                    }
                  },
                  child: const Text('Lưu lại'),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
    );
  }

  Future<void> onEditVocabulary(int index) async {
    final item = items[index];
    final wordController = TextEditingController(text: item.word);
    final translationController = TextEditingController(text: item.translation);

    final result = await Get.bottomSheet<_VocabularyEditResult>(
      _EditVocabularySheet(
        title: 'Sửa từ vựng',
        confirmLabel: 'Cập nhật',
        wordController: wordController,
        translationController: translationController,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );

    wordController.dispose();
    translationController.dispose();

    if (result == null) {
      return;
    }

    final newWord = result.word;
    final newTranslation = result.translation;
    if (newWord == item.word && newTranslation == item.translation) {
      return;
    }

    items[index] = VocabularyTopicItem(
      word: newWord,
      ipa: item.ipa,
      translation: newTranslation,
      exampleEn: item.exampleEn,
      exampleVi: item.exampleVi,
      status: item.status,
    );
    items.refresh();
  }

  void onDeleteVocabulary(int index) {
    final item = items[index];
    Get.bottomSheet(
      Builder(
        builder: (context) {
          final bottomInset = MediaQuery.of(context).viewInsets.bottom;
          return SafeArea(
            top: false,
            child: Container(
              padding: EdgeInsets.fromLTRB(24, 28, 24, 32 + bottomInset),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  SizedBox(height: 24),
                  Image.asset(
                    'assets/images/chimcanhcut/chim_nhachoc.png',
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Xoá từ vựng',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  Text.rich(
                    TextSpan(
                      text: 'Từ vựng này sẽ bị xoá vĩnh viễn khỏi chủ đề\n',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      children: [
                        TextSpan(
                          text: '"$topicName"',
                          style: const TextStyle(
                            color: Color(0xFF2DBF7F),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        items.removeAt(index);
                        items.refresh();
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5A5F),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Xoá',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      foregroundColor: AppColors.textSecondary,
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Huỷ'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      backgroundColor: Colors.black.withOpacity(0.25),
      isScrollControlled: true,
    );
  }

  Future<void> _persistWord(VocabularyTopicItem item) async {
    if (!Get.isRegistered<AuthService>() || !AuthService.to.isLoggedIn) {
      throw Exception('Bạn cần đăng nhập để lưu từ vựng.');
    }
    final userId = AuthService.to.currentUserId;
    final saved = await VocabularyService.to.saveCustomWord(
      userId: userId,
      word: item.word,
      translation: item.translation,
      phonetic: item.ipa,
      example: item.exampleEn,
      category: topicName,
    );
    if (saved == null) {
      throw Exception('Không thể lưu từ vào thư viện.');
    }
  }

  Future<({String ipa, String exampleEn, String exampleVi})> _fetchWordDetails(
    String word,
    String translation,
  ) async {
    final fallbackExamples = ExampleSentenceService.generate(
      word: word,
      translation: translation,
      topic: topicName,
    );

    String ipa = '';
    String exampleEn = fallbackExamples.english;

    try {
      final url = Uri.parse(
        'https://api.dictionaryapi.dev/api/v2/entries/en/${Uri.encodeComponent(word)}',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data is List && data.isNotEmpty) {
          final first = data.first;
          ipa = first['phonetic'] ?? '';
          if (ipa.isEmpty &&
              first['phonetics'] is List &&
              first['phonetics'].isNotEmpty) {
            final firstPhonetic = first['phonetics'].first;
            if (firstPhonetic is Map && firstPhonetic['text'] is String) {
              ipa = firstPhonetic['text'] as String;
            }
          }
          if (first['meanings'] is List && first['meanings'].isNotEmpty) {
            for (final meaning in first['meanings']) {
              if (meaning is Map &&
                  meaning['definitions'] is List &&
                  meaning['definitions'].isNotEmpty) {
                final def = meaning['definitions'].first;
                if (def is Map && def['example'] is String) {
                  exampleEn = def['example'] as String;
                  break;
                }
              }
            }
          }
        }
      }
    } catch (_) {
      // ignore and use fallback
    }

    if (ipa.trim().isEmpty) {
      ipa = '/${word.toLowerCase().replaceAll(RegExp(r"[^a-z]"), "")}/';
    }

    return (
      ipa: ipa,
      exampleEn: exampleEn,
      exampleVi: fallbackExamples.vietnamese,
    );
  }

  String statusLabel(VocabularyLearningStatus status) {
    switch (status) {
      case VocabularyLearningStatus.notStarted:
        return 'chưa học';
      case VocabularyLearningStatus.learning:
        return 'đang học';
      case VocabularyLearningStatus.learned:
        return 'đã học';
    }
  }

  void updateWordStatus(String word, VocabularyLearningStatus newStatus) {
    final index = items.indexWhere((item) => item.word == word);
    if (index != -1) {
      final item = items[index];
      items[index] = VocabularyTopicItem(
        word: item.word,
        ipa: item.ipa,
        translation: item.translation,
        exampleEn: item.exampleEn,
        exampleVi: item.exampleVi,
        status: newStatus,
      );
      items.refresh();
    }
  }

  int get totalWords => items.length;

  static List<VocabularyTopicItem> defaultAnimalVocabulary() => [
        VocabularyTopicItem(
          word: 'Zebra',
          ipa: '/ˈziː.brə/',
          translation: 'ngựa vằn',
          exampleEn: 'The zebra has black and white stripes.',
          exampleVi: 'Con ngựa vằn có những sọc đen trắng.',
          status: VocabularyLearningStatus.notStarted,
        ),
        VocabularyTopicItem(
          word: 'Dog',
          ipa: '/dɒɡ/',
          translation: 'chó',
          exampleEn: 'The dog is playing in the garden.',
          exampleVi: 'Chú chó đang chơi trong vườn.',
          status: VocabularyLearningStatus.learning,
        ),
        VocabularyTopicItem(
          word: 'Cat',
          ipa: '/kæt/',
          translation: 'mèo',
          exampleEn: 'The cat is sleeping on the sofa.',
          exampleVi: 'Chú mèo đang ngủ trên ghế sofa.',
          status: VocabularyLearningStatus.learned,
        ),
        VocabularyTopicItem(
          word: 'Elephant',
          ipa: '/ˈel.ə.fənt/',
          translation: 'voi',
          exampleEn: 'The elephant has a long trunk.',
          exampleVi: 'Con voi có chiếc vòi dài.',
          status: VocabularyLearningStatus.learning,
        ),
        VocabularyTopicItem(
          word: 'Tiger',
          ipa: '/ˈtaɪ.ɡər/',
          translation: 'hổ',
          exampleEn: 'The tiger lives in the jungle.',
          exampleVi: 'Con hổ sống trong rừng già.',
          status: VocabularyLearningStatus.learned,
        ),
        VocabularyTopicItem(
          word: 'Lion',
          ipa: '/ˈlaɪ.ən/',
          translation: 'sư tử',
          exampleEn: 'The lion is the king of the jungle.',
          exampleVi: 'Sư tử là chúa tể của rừng xanh.',
          status: VocabularyLearningStatus.learned,
        ),
        VocabularyTopicItem(
          word: 'Monkey',
          ipa: '/ˈmʌŋ.ki/',
          translation: 'khỉ',
          exampleEn: 'The monkey jumped from tree to tree.',
          exampleVi: 'Chú khỉ nhảy từ cây này sang cây khác.',
          status: VocabularyLearningStatus.notStarted,
        ),
        VocabularyTopicItem(
          word: 'Giraffe',
          ipa: '/dʒəˈræf/',
          translation: 'hươu cao cổ',
          exampleEn: 'The giraffe eats leaves from tall trees.',
          exampleVi: 'Hươu cao cổ ăn lá từ những cây cao.',
          status: VocabularyLearningStatus.learning,
        ),
        VocabularyTopicItem(
          word: 'Bear',
          ipa: '/beər/',
          translation: 'gấu',
          exampleEn: 'The bear is catching fish in the river.',
          exampleVi: 'Con gấu đang bắt cá ở con sông.',
          status: VocabularyLearningStatus.notStarted,
        ),
        VocabularyTopicItem(
          word: 'Kangaroo',
          ipa: '/ˌkæŋ.ɡəˈruː/',
          translation: 'chuột túi',
          exampleEn: 'The kangaroo carries its baby in a pouch.',
          exampleVi: 'Chuột túi mang con trong túi trước bụng.',
          status: VocabularyLearningStatus.notStarted,
        ),
      ];
}

class _VocabularyEditResult {
  _VocabularyEditResult({
    required this.word,
    required this.translation,
  });

  final String word;
  final String translation;
}

class _EditField extends StatelessWidget {
  const _EditField({
    required this.controller,
    required this.hintText,
    required this.label,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(
        color: AppColors.primaryBlue,
        width: 1.2,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hintText,
            hintStyle: const TextStyle(
              color: AppColors.textHint,
              fontSize: 15,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: baseBorder,
            focusedBorder: baseBorder.copyWith(
              borderSide: const BorderSide(
                color: AppColors.primaryAccent,
                width: 1.8,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EditVocabularySheet extends StatefulWidget {
  const _EditVocabularySheet({
    required this.title,
    required this.confirmLabel,
    required this.wordController,
    required this.translationController,
  });

  final String title;
  final String confirmLabel;
  final TextEditingController wordController;
  final TextEditingController translationController;

  @override
  State<_EditVocabularySheet> createState() => _EditVocabularySheetState();
}

class _EditVocabularySheetState extends State<_EditVocabularySheet> {
  late bool _canSubmit;

  @override
  void initState() {
    super.initState();
    _canSubmit = _validate();
    widget.wordController.addListener(_handleChange);
    widget.translationController.addListener(_handleChange);
  }

  @override
  void dispose() {
    widget.wordController.removeListener(_handleChange);
    widget.translationController.removeListener(_handleChange);
    super.dispose();
  }

  void _handleChange() {
    final next = _validate();
    if (next != _canSubmit) {
      setState(() {
        _canSubmit = next;
      });
    }
  }

  bool _validate() {
    return widget.wordController.text.trim().isNotEmpty &&
        widget.translationController.text.trim().isNotEmpty;
  }

  void _submit() {
    if (!_canSubmit) return;
    final word = widget.wordController.text.trim();
    final translation = widget.translationController.text.trim();
    FocusScope.of(context).unfocus();
    Get.back(
      result: _VocabularyEditResult(
        word: word,
        translation: translation,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: bottomInset),
        child: SafeArea(
          top: false,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 54,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.shadowLight,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _EditField(
                    controller: widget.wordController,
                    label: 'Từ vựng',
                    hintText: 'Nhập từ vựng',
                  ),
                  const SizedBox(height: 18),
                  _EditField(
                    controller: widget.translationController,
                    label: 'Nghĩa',
                    hintText: 'Nhập nghĩa',
                  ),
                  const SizedBox(height: 26),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _canSubmit ? _submit : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _canSubmit
                            ? AppColors.buttonActive
                            : AppColors.buttonDisabled,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        disabledBackgroundColor: AppColors.buttonDisabled,
                        elevation: 0,
                      ),
                      child: Text(
                        widget.confirmLabel,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('Huỷ'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
