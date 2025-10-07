import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../data/services/realm_service.dart';
import '../../../data/models/vocabulary_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_widgets.dart';

class DetectionResultView extends StatefulWidget {
  const DetectionResultView({super.key});

  @override
  State<DetectionResultView> createState() => _DetectionResultViewState();
}

class _DetectionResultViewState extends State<DetectionResultView> {
  late String detectedImageUrl;
  late List<String> words;
  late File? originalImage;

  Map<String, Map<String, String>> wordData = {}; // word -> {phonetic, meaning, example, topic}
  Set<String> selectedWords = {};
  bool isLoading = true;

  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();

    // Get arguments
    final args = Get.arguments as Map<String, dynamic>;
    detectedImageUrl = args['detectedImageUrl'] as String;
    words = List<String>.from(args['words'] as List);
    originalImage = args['originalImage'] as File?;

    _initTts();
    _fetchWordMeanings();
  }

  Future<void> _initTts() async {
    // Check available languages
    List<dynamic> languages = await flutterTts.getLanguages;
    print('📢 Hệ thống hỗ trợ các ngôn ngữ: $languages');

    if (languages.contains('en-US')) {
      await flutterTts.setLanguage('en-US');
    } else {
      print('⚠️ Thiết bị không hỗ trợ ngôn ngữ en-US!');
    }

    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.45);
    await flutterTts.setVolume(1.0);
  }

  Future<void> _speak(String word) async {
    // Stop any ongoing speech first
    await flutterTts.stop();

    // Ensure TTS is ready
    List<dynamic> languages = await flutterTts.getLanguages;

    if (languages.contains('en-US')) {
      await flutterTts.setLanguage('en-US');
    } else {
      print('⚠️ Thiết bị không hỗ trợ ngôn ngữ en-US!');
      return;
    }

    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.45);

    // Small delay to ensure previous stop completed
    await Future.delayed(const Duration(milliseconds: 100));

    await flutterTts.speak(word);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  /// Fetch word meanings from Dictionary API + Google Translate API
  Future<void> _fetchWordMeanings() async {
    const dictionaryApiUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en/';
    const translateApiUrl =
        'https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=vi&dt=t&q=';

    for (String word in words) {
      try {
        // Fetch from dictionary API
        var response = await http.get(Uri.parse(dictionaryApiUrl + word));

        if (response.statusCode == 200) {
          var data = jsonDecode(utf8.decode(response.bodyBytes));

          if (data.isNotEmpty && data[0].containsKey('meanings')) {
            String phonetic = data[0]['phonetic'] ?? '';
            String example = '';

            // Get simple definition (prioritize nouns)
            String englishMeaning = '';
            for (var meaning in data[0]['meanings']) {
              if (meaning['partOfSpeech'] == 'noun' &&
                  meaning['definitions'].isNotEmpty) {
                englishMeaning = meaning['definitions'][0]['definition'];
                example = meaning['definitions'][0]['example'] ?? '';
                break;
              }
            }

            // If no noun, get first available
            if (englishMeaning.isEmpty && data[0]['meanings'].isNotEmpty) {
              englishMeaning =
                  data[0]['meanings'][0]['definitions'][0]['definition'];
              example = data[0]['meanings'][0]['definitions'][0]['example'] ?? '';
            }

            // Translate to Vietnamese
            var translationResponse = await http.get(
              Uri.parse(translateApiUrl + Uri.encodeComponent(word)),
            );

            String vietnameseMeaning = word;
            if (translationResponse.statusCode == 200) {
              var translationData = jsonDecode(translationResponse.body);
              vietnameseMeaning = translationData[0][0][0];
            }

            setState(() {
              wordData[word] = {
                'phonetic': phonetic,
                'meaning': vietnameseMeaning.trim(),
                'example': example,
                'topic': 'chọn chủ đề',
              };
            });
          } else {
            setState(() {
              wordData[word] = {
                'phonetic': '',
                'meaning': 'Không tìm thấy nghĩa',
                'example': '',
                'topic': 'chọn chủ đề',
              };
            });
          }
        } else {
          setState(() {
            wordData[word] = {
              'phonetic': '',
              'meaning': 'Không tìm thấy nghĩa',
              'example': '',
              'topic': 'chọn chủ đề',
            };
          });
        }
      } catch (e) {
        setState(() {
          wordData[word] = {
            'phonetic': '',
            'meaning': 'Lỗi khi lấy dữ liệu',
            'example': '',
            'topic': 'chọn chủ đề',
          };
        });
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  /// Save selected words to Realm
  Future<void> _saveToVocabulary({bool shouldShare = false}) async {
    if (selectedWords.isEmpty) {
      Get.snackbar(
        'Thông báo',
        'Vui lòng chọn ít nhất 1 từ vựng',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.xpGold,
        colorText: AppColors.textWhite,
      );
      return;
    }

    try {
      final realm = RealmService.to.realm;
      if (realm == null) {
        throw Exception('Realm chưa khởi tạo');
      }

      const userId = 'current_user_id'; // TODO: Replace with actual user ID
      final now = DateTime.now();

      realm.write(() {
        for (String word in selectedWords) {
          final data = wordData[word];
          if (data == null) continue;

          // Create vocabulary if not exists
          final vocabId = '${word}_${now.millisecondsSinceEpoch}';
          final vocab = Vocabulary(
            vocabId,
            word,
            data['meaning'] ?? 'No definition', // definition
            'beginner', // difficulty
            data['topic'] == 'chọn chủ đề' ? 'Khác' : data['topic']!, // category
            0, // frequency
            true, // isActive
            now, // createdAt
            phonetic: data['phonetic'],
            translation: data['meaning'],
            example: data['example'],
            updatedAt: now,
          );

          realm.add(vocab, update: true);

          // Create user vocabulary
          final userVocabId = '${userId}_$vocabId';
          final userVocab = UserVocabulary(
            userVocabId,
            userId,
            vocabId,
            1, // level
            0, // repetitions
            2.5, // easeFactor
            0, // interval
            0, // correctCount
            0, // incorrectCount
            false, // isMastered
            false, // isFavorite
            'new', // status
            now, // createdAt
            updatedAt: now,
          );

          realm.add(userVocab, update: true);
        }
      });

      if (shouldShare) {
        // TODO: Implement sharing logic
        Get.snackbar(
          'Thành công',
          'Đã lưu ${selectedWords.length} từ vựng và đăng tải',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.buttonSuccess,
          colorText: AppColors.textWhite,
        );
      } else {
        Get.snackbar(
          'Thành công',
          'Đã lưu ${selectedWords.length} từ vựng',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.buttonSuccess,
          colorText: AppColors.textWhite,
        );
      }

      // Go back to home
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể lưu từ vựng: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.buttonDanger,
        colorText: AppColors.textWhite,
      );
    }
  }

  void _showTopicDialog(String word) {
    // Get existing categories from Realm
    final realm = RealmService.to.realm;
    Set<String> topics = {};

    if (realm != null) {
      final vocabs = realm.all<Vocabulary>();
      for (var vocab in vocabs) {
        if (vocab.category.isNotEmpty && vocab.category != 'Camera Detection') {
          topics.add(vocab.category);
        }
      }
    }

    // Add default topics if none exist
    if (topics.isEmpty) {
      topics = {
        'Động vật',
        'Thực phẩm',
        'Đồ vật',
        'Giao thông',
        'Thiên nhiên',
        'Khác',
      };
    }

    final topicList = topics.toList()..sort();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chọn chủ đề cho "$word"'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: topicList.length,
            itemBuilder: (context, index) {
              final topic = topicList[index];
              return ListTile(
                title: Text(topic),
                onTap: () {
                  setState(() {
                    wordData[word]!['topic'] = topic;
                  });
                  Get.back();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _selectAllTopics() {
    // Get existing categories from Realm
    final realm = RealmService.to.realm;
    Set<String> topics = {};

    if (realm != null) {
      final vocabs = realm.all<Vocabulary>();
      for (var vocab in vocabs) {
        if (vocab.category.isNotEmpty && vocab.category != 'Camera Detection') {
          topics.add(vocab.category);
        }
      }
    }

    // Add default topics if none exist
    if (topics.isEmpty) {
      topics = {
        'Động vật',
        'Thực phẩm',
        'Đồ vật',
        'Giao thông',
        'Thiên nhiên',
        'Khác',
      };
    }

    final topicList = topics.toList()..sort();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chọn chủ đề cho tất cả'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: topicList.length,
            itemBuilder: (context, index) {
              final topic = topicList[index];
              return ListTile(
                title: Text(topic),
                onTap: () {
                  setState(() {
                    for (var word in words) {
                      if (wordData[word] != null) {
                        wordData[word]!['topic'] = topic;
                      }
                    }
                  });
                  Get.back();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: const BoxDecoration(
                color: AppColors.backgroundLight,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.arrow_back,
                      size: 24.sp,
                      color: AppColors.textPrimary,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Kết quả nhận diện',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Detected image (300x300px)
                    Center(
                      child: SizedBox(
                        width: 300.w,
                        height: 300.w,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: Image.network(
                            '$detectedImageUrl?t=${DateTime.now().millisecondsSinceEpoch}',
                            width: 300.w,
                            height: 300.w,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 300.w,
                                height: 300.w,
                                color: AppColors.surfaceLight,
                                child: Center(
                                  child: Icon(Icons.error, color: AppColors.textSecondary, size: 50.sp),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Select all topics button
                    Row(
                      children: [
                        Text(
                          'Chọn chủ đề cho tất cả:',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        ElevatedButton(
                          onPressed: _selectAllTopics,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonActive,
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'chọn chủ đề',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textWhite,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    // Loading or word list
                    if (isLoading)
                      Padding(
                        padding: EdgeInsets.all(32.h),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.buttonActive,
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: words.length,
                        itemBuilder: (context, index) {
                          String word = words[index];
                          var data = wordData[word];
                          bool isSelected = selectedWords.contains(word);

                          return Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF98ECF8) : null,
                              gradient: isSelected ? null : const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: [0.0, 0.25, 1.0],
                                colors: [
                                  Color(0xFFE0E0E0),
                                  Color(0xFFE5FFFD),
                                  Color(0xFFE5FFFD),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: AppColors.buttonActive,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Radio button
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        selectedWords.remove(word);
                                      } else {
                                        selectedWords.add(word);
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: 24.w,
                                    height: 24.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                          ? AppColors.buttonActive
                                          : AppColors.textHint,
                                        width: 2,
                                      ),
                                      color: AppColors.backgroundWhite,
                                    ),
                                    child: isSelected
                                      ? Center(
                                          child: Container(
                                            width: 12.w,
                                            height: 12.w,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.buttonActive,
                                            ),
                                          ),
                                        )
                                      : null,
                                  ),
                                ),
                                SizedBox(width: 12.w),

                                // Word info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        word,
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      if (data != null) ...[
                                        SizedBox(height: 4.h),
                                        Row(
                                          children: [
                                            if (data['phonetic']!.isNotEmpty) ...[
                                              Text(
                                                data['phonetic']!,
                                                style: TextStyle(
                                                  fontSize: 13.sp,
                                                  color: AppColors.textSecondary,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              Text(
                                                ' • ',
                                                style: TextStyle(
                                                  fontSize: 13.sp,
                                                  color: AppColors.textSecondary,
                                                ),
                                              ),
                                            ],
                                            Expanded(
                                              child: Text(
                                                data['meaning']!,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                      SizedBox(height: 8.h),
                                      Row(
                                        children: [
                                          Text(
                                            'Chủ đề: ',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => _showTopicDialog(word),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12.w,
                                                vertical: 4.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.buttonActive,
                                                borderRadius: BorderRadius.circular(12.r),
                                              ),
                                              child: Text(
                                                data?['topic'] ?? 'chọn chủ đề',
                                                style: TextStyle(
                                                  fontSize: 11.sp,
                                                  color: AppColors.textWhite,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Speaker icon
                                IconButton(
                                  onPressed: () => _speak(word),
                                  icon: Icon(
                                    Icons.volume_up,
                                    color: AppColors.buttonActive,
                                    size: 28.sp,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),

            // Bottom buttons
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: const BoxDecoration(
                color: AppColors.backgroundWhite,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppWidgets.primaryButton(
                      text: 'Lưu từ vựng',
                      onPressed: () => _saveToVocabulary(shouldShare: false),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: AppWidgets.primaryButton(
                      text: 'Lưu và đăng tải',
                      onPressed: () => _saveToVocabulary(shouldShare: true),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
