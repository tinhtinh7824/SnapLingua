import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:snaplingua/app/data/models/realm/community_model.dart';
import 'package:snaplingua/app/data/models/realm/vocabulary_model.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_widgets.dart';
import '../../../data/services/realm_service.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/vocabulary_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../data/services/daily_progress_service.dart';
import '../../../routes/app_pages.dart';
import '../../community/controllers/community_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../review/controllers/review_controller.dart';
class DetectionResultView extends StatefulWidget {
  const DetectionResultView({super.key});

  @override
  State<DetectionResultView> createState() => _DetectionResultViewState();
}

class _DetectionResultViewState extends State<DetectionResultView> {
  late String detectedImageUrl;
  late List<String> words;
  late File? originalImage;

  Map<String, Map<String, String>> wordData =
      {}; // word -> {phonetic, meaning, example, topic}
  Set<String> selectedWords = {};
  bool isLoading = true;
  bool _isSavingLocally = false;
  bool _isSavingAndSharing = false;

  final FlutterTts flutterTts = FlutterTts();
  static const String _guestUserId = 'guest';

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

  Widget _buildDetectedImage() {
    final cacheBust = DateTime.now().millisecondsSinceEpoch;
    final uri = Uri.tryParse(detectedImageUrl);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      return Image.network(
        '$detectedImageUrl?t=$cacheBust',
        width: 300.w,
        height: 300.w,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _imageErrorPlaceholder();
        },
      );
    }

    final file = File(detectedImageUrl);
    if (file.existsSync()) {
      return Image.file(
        file,
        width: 300.w,
        height: 300.w,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _imageErrorPlaceholder();
        },
      );
    }

    return _imageErrorPlaceholder();
  }

  Widget _imageErrorPlaceholder() {
    return Container(
      width: 300.w,
      height: 300.w,
      color: AppColors.surfaceLight,
      child: Center(
        child: Icon(
          Icons.error,
          color: AppColors.textSecondary,
          size: 50.sp,
        ),
      ),
    );
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
              example =
                  data[0]['meanings'][0]['definitions'][0]['example'] ?? '';
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
                'definition': englishMeaning.isNotEmpty
                    ? englishMeaning.trim()
                    : vietnameseMeaning.trim(),
                'example': example,
                'topic': 'chọn chủ đề',
              };
            });
          } else {
            setState(() {
              wordData[word] = {
                'phonetic': '',
                'meaning': 'Không tìm thấy nghĩa',
                'definition': '',
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
              'definition': '',
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
            'definition': '',
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
    if (_isSavingLocally || _isSavingAndSharing) {
      return;
    }

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

    final unassignedTopics = selectedWords.where((word) {
      final topic = wordData[word]?['topic'] ?? 'chọn chủ đề';
      return topic == 'chọn chủ đề' || topic.trim().isEmpty;
    }).toList(growable: false);

    if (unassignedTopics.isNotEmpty) {
      Get.snackbar(
        'Thông báo',
        'Vui lòng chọn chủ đề cho: ${unassignedTopics.join(', ')}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.xpGold,
        colorText: AppColors.textWhite,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    try {
      final realm = RealmService.to.realm;
      if (realm == null) {
        throw Exception('Realm chưa khởi tạo');
      }

      if (mounted) {
        setState(() {
          if (shouldShare) {
            _isSavingAndSharing = true;
          } else {
            _isSavingLocally = true;
          }
        });
      }

      final now = DateTime.now();

      realm.write(() {
        for (final word in selectedWords) {
          final data = wordData[word];
          if (data == null) continue;

          final topicName = data['topic']!.trim();

          // Ensure category exists
          final existingCategoryResults =
              realm.query<Category>('name == \$0', [topicName]);
          if (existingCategoryResults.isNotEmpty) {
            final category = existingCategoryResults.first;
            if (!category.isActive) {
              category.isActive = true;
            }
          } else {
            final categoryId = _generateCategoryId(topicName, now);
            final sortOrder = realm.all<Category>().length;
            final newCategory = Category(
              categoryId,
              topicName,
              sortOrder,
              true,
              now,
            );
            realm.add(newCategory);
          }

          // Find existing vocabulary in this category
          final existingVocabResults = realm.query<Vocabulary>(
            'word == \$0 AND category == \$1',
            [word, topicName],
          );

          Vocabulary vocab;
          if (existingVocabResults.isNotEmpty) {
            vocab = existingVocabResults.first;
            vocab
              ..definition = (data['definition']?.isNotEmpty ?? false)
                  ? data['definition']!
                  : (data['meaning'] ?? vocab.definition)
              ..translation = data['meaning'] ?? vocab.translation
              ..phonetic = data['phonetic'] ?? vocab.phonetic
              ..example = data['example'] ?? vocab.example
              ..updatedAt = now
              ..category = topicName;
          } else {
            final vocabId =
                '${word}_${topicName}_${now.millisecondsSinceEpoch}';
            vocab = Vocabulary(
              vocabId,
              word,
              (data['definition']?.isNotEmpty ?? false)
                  ? data['definition']!
                  : (data['meaning'] ?? 'No definition'),
              'beginner',
              topicName,
              0,
              true,
              now,
              phonetic: data['phonetic'],
              translation: data['meaning'],
              example: data['example'],
              updatedAt: now,
            );
            realm.add(vocab);
          }

          // Ensure user vocabulary record
          final userVocabResults = realm.query<UserVocabulary>(
            'userId == \$0 AND vocabularyId == \$1',
            [_resolveUserId(), vocab.id],
          );

          if (userVocabResults.isNotEmpty) {
            final existingUserVocab = userVocabResults.first;
            existingUserVocab.updatedAt = now;
          } else {
            final userId = _resolveUserId();
            final userVocab = UserVocabulary(
              '${userId}_${vocab.id}',
              userId,
              vocab.id,
              1,
              0,
              2.5,
              0,
              0,
              0,
              false,
              false,
              VocabularyService.statusNotStarted,
              now,
              nextReviewDate: null,
              updatedAt: now,
            );
            realm.add(userVocab);
          }
        }
      });

      if (Get.isRegistered<ReviewController>()) {
        await Get.find<ReviewController>().loadCategories();
      }

      final communityItems = _buildCommunityVocabularyItems();

      // Cộng XP cơ bản khi lưu vào kho: +1 mỗi từ (dù có chia sẻ hay không)
      final baseXp = selectedWords.length * 1;
      await _awardXp(baseXp, 'camera_save', selectedWords.length);

      if (shouldShare) {
        await _shareToCommunity(communityItems);
        return;
      }

      Get.snackbar(
        'Thành công',
        'Đã lưu ${selectedWords.length} từ vựng',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.buttonSuccess,
        colorText: AppColors.textWhite,
      );

      // Điều hướng sang Ôn tập: ưu tiên quay lại Home rồi chuyển tab,
      // hạn chế offAll để tránh rebuild nặng gây đơ ứng dụng.
      if (Get.isRegistered<HomeController>()) {
        // Pop về Home nếu đã có trong stack; nếu không có thì offAll tới Home
        var reachedHome = false;
        Get.until((route) {
          final isHome = route.settings.name == Routes.home;
          if (isHome) reachedHome = true;
          return isHome;
        });
        if (!reachedHome) {
          await Get.offAllNamed(Routes.home);
        }
        // Chuyển tab Ôn tập sau khi frame hiện tại kết thúc
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (Get.isRegistered<HomeController>()) {
            HomeController.to.changeTab(1);
          }
        });
      } else {
        await Get.offAllNamed(Routes.review);
      }
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể lưu từ vựng: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.buttonDanger,
        colorText: AppColors.textWhite,
      );
    } finally {
      if (mounted) {
        setState(() {
          if (shouldShare) {
            _isSavingAndSharing = false;
          } else {
            _isSavingLocally = false;
          }
        });
      }
    }
  }

  Future<void> _awardXp(int amount, String action, int wordsCount) async {
    try {
      final userId = _resolveUserId();
      if (Get.isRegistered<DailyProgressService>()) {
        await DailyProgressService.to.awardXp(
          userId: userId,
          amount: amount,
          activity: DailyActivityType.camera,
          sourceType: 'camera',
          action: action,
          wordsCount: wordsCount,
          metadata: {
            'words_saved': wordsCount,
          },
        );
        return;
      }

      final realm = RealmService.to.realm;
      if (realm == null) return;
      final sessionId = 'session_${DateTime.now().millisecondsSinceEpoch}';
      realm.write(() {
        realm.add(UserSession(
          sessionId,
          userId,
          DateTime.now(),
          amount,
          wordsCount,
          0,
          0,
          endTime: DateTime.now(),
          activityType: action,
        ));
      });

      if (userId != 'guest') {
        await FirestoreService.to.addXpTransaction(
          userId: userId,
          sourceType: 'camera',
          action: action,
          amount: amount,
          wordsCount: wordsCount,
          metadata: {
            'words_saved': wordsCount,
          },
        );
      }
    } catch (e) {
      // Silent fail, do not block UX
      // print('Failed to award XP: $e');
    }
  }

  String _generateCategoryId(String name, DateTime timestamp) {
    final normalized = name
        .toLowerCase()
        .replaceAll(RegExp('[^a-z0-9]+'), '_')
        .replaceAll(RegExp('_+'), '_')
        .trim();
    if (normalized.isEmpty) {
      return 'category_${timestamp.millisecondsSinceEpoch}';
    }
    return 'category_$normalized';
  }

  List<CommunityVocabularyItem> _buildCommunityVocabularyItems() {
    return selectedWords.map((word) {
      final data = wordData[word] ?? {};
      final topic = data['topic'];
      final translation = (data['meaning'] ?? word).toString();
      return CommunityVocabularyItem(
        label: word,
        confidence: 1.0,
        headword: word,
        phonetic: data['phonetic'] ?? '',
        translation: translation,
        topic: (topic != null && topic != 'chọn chủ đề') ? topic : null,
      );
    }).toList(growable: false);
  }

  Future<void> _shareToCommunity(
      List<CommunityVocabularyItem> vocabularyItems) async {
    try {
      // Thưởng chia sẻ: +5 XP một lần (không theo số từ)
      await _awardXp(5, 'camera_share', vocabularyItems.length);

      final communityController = _ensureCommunityController();
      await communityController.addUserPost(
        imageUrl: detectedImageUrl,
        vocabularyItems: vocabularyItems,
        caption: 'Khám phá từ vựng mới',
      );

      if (Get.isRegistered<HomeController>()) {
        HomeController.to.changeTab(2);
      }

      var reachedHome = false;
      Get.until((route) {
        final isHome = route.settings.name == Routes.home;
        if (isHome) {
          reachedHome = true;
        }
        return isHome;
      });

      if (!reachedHome) {
        await Get.offAllNamed(Routes.home);
      }

      Future.microtask(() {
        if (Get.isRegistered<HomeController>()) {
          HomeController.to.changeTab(2);
        }
      });

      Get.snackbar(
        'Thành công',
        'Đã lưu ${vocabularyItems.length} từ vựng và chia sẻ lên cộng đồng!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.buttonSuccess,
        colorText: AppColors.textWhite,
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể đăng bài: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.buttonDanger,
        colorText: AppColors.textWhite,
      );
    }
  }

  String _resolveUserId() {
    if (Get.isRegistered<AuthService>()) {
      final auth = AuthService.to;
      if (auth.isLoggedIn && auth.currentUserId.isNotEmpty) {
        return auth.currentUserId;
      }
    }
    return _guestUserId;
  }

  CommunityController _ensureCommunityController() {
    if (Get.isRegistered<CommunityController>()) {
      return Get.find<CommunityController>();
    }
    Get.put(CommunityController());
    return Get.find<CommunityController>();
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

      final storedCategories = realm.all<Category>();
      for (final category in storedCategories) {
        if (category.isActive) {
          topics.add(category.name);
        }
      }
    }

    // Add default topics
    topics.addAll({
      'Động vật',
      'Thực phẩm',
      'Đồ vật',
      'Giao thông',
      'Thiên nhiên',
      'Công nghệ',
      'Giáo dục',
      'Y tế',
      'Thể thao',
      'Du lịch',
      'Khác',
    });

    final topicList = topics.toList()..sort();
    final newTopicController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chọn chủ đề cho "$word"'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Create new topic section
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5FFFD),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.buttonActive.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tạo chủ đề mới:',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: newTopicController,
                            decoration: InputDecoration(
                              hintText: 'Nhập tên chủ đề...',
                              hintStyle: TextStyle(
                                color: AppColors.textHint,
                                fontSize: 14.sp,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(
                                  color: AppColors.buttonActive
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: const BorderSide(
                                  color: AppColors.buttonActive,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        ElevatedButton(
                          onPressed: () {
                            final newTopic = newTopicController.text.trim();
                            if (newTopic.isNotEmpty) {
                              setState(() {
                                wordData[word]!['topic'] = newTopic;
                              });
                              if (realm != null) {
                                final existingCategory = realm
                                    .query<Category>('name == \$0', [newTopic]);
                                if (existingCategory.isEmpty) {
                                  final now = DateTime.now();
                                  final sortOrder =
                                      realm.all<Category>().length;
                                  realm.write(() {
                                    realm.add(
                                      Category(
                                        _generateCategoryId(newTopic, now),
                                        newTopic,
                                        sortOrder,
                                        true,
                                        now,
                                      ),
                                    );
                                  });
                                }
                              }
                              Get.back();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonActive,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Tạo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Hoặc chọn chủ đề có sẵn:',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              // Existing topics list
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: topicList.length,
                  itemBuilder: (context, index) {
                    final topic = topicList[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 4.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: Colors.white,
                      ),
                      child: ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 2.h,
                        ),
                        title: Text(
                          topic,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: AppColors.buttonActive,
                          size: 20.sp,
                        ),
                        onTap: () {
                          setState(() {
                            wordData[word]!['topic'] = topic;
                          });
                          Get.back();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Đóng',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
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

      final storedCategories = realm.all<Category>();
      for (final category in storedCategories) {
        if (category.isActive) {
          topics.add(category.name);
        }
      }
    }

    // Add default topics
    topics.addAll({
      'Động vật',
      'Thực phẩm',
      'Đồ vật',
      'Giao thông',
      'Thiên nhiên',
      'Công nghệ',
      'Giáo dục',
      'Y tế',
      'Thể thao',
      'Du lịch',
      'Khác',
    });

    final topicList = topics.toList()..sort();
    final newTopicController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chọn chủ đề cho tất cả từ'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Create new topic section
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5FFFD),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.buttonActive.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tạo chủ đề mới:',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: newTopicController,
                            decoration: InputDecoration(
                              hintText: 'Nhập tên chủ đề...',
                              hintStyle: TextStyle(
                                color: AppColors.textHint,
                                fontSize: 14.sp,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(
                                  color: AppColors.buttonActive
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: const BorderSide(
                                  color: AppColors.buttonActive,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        ElevatedButton(
                          onPressed: () {
                            final newTopic = newTopicController.text.trim();
                            if (newTopic.isNotEmpty) {
                              setState(() {
                                for (var word in words) {
                                  if (wordData[word] != null) {
                                    wordData[word]!['topic'] = newTopic;
                                  }
                                }
                              });
                              if (realm != null) {
                                final existingCategory = realm
                                    .query<Category>('name == \$0', [newTopic]);
                                if (existingCategory.isEmpty) {
                                  final now = DateTime.now();
                                  final sortOrder =
                                      realm.all<Category>().length;
                                  realm.write(() {
                                    realm.add(
                                      Category(
                                        _generateCategoryId(newTopic, now),
                                        newTopic,
                                        sortOrder,
                                        true,
                                        now,
                                      ),
                                    );
                                  });
                                }
                              }
                              Get.back();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonActive,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Tạo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Hoặc chọn chủ đề có sẵn:',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              // Existing topics list
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: topicList.length,
                  itemBuilder: (context, index) {
                    final topic = topicList[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 4.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: Colors.white,
                      ),
                      child: ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 2.h,
                        ),
                        title: Text(
                          topic,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: AppColors.buttonActive,
                          size: 20.sp,
                        ),
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
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Đóng',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
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
                          child: _buildDetectedImage(),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 8.h),
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
                        child: const Center(
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
                              color:
                                  isSelected ? const Color(0xFF98ECF8) : null,
                              gradient: isSelected
                                  ? null
                                  : const LinearGradient(
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
                                              decoration: const BoxDecoration(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            if (data['phonetic']!
                                                .isNotEmpty) ...[
                                              Text(
                                                data['phonetic']!,
                                                style: TextStyle(
                                                  fontSize: 13.sp,
                                                  color:
                                                      AppColors.textSecondary,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              Text(
                                                ' • ',
                                                style: TextStyle(
                                                  fontSize: 13.sp,
                                                  color:
                                                      AppColors.textSecondary,
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
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
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
                      enabled: !_isSavingLocally && !_isSavingAndSharing,
                      isLoading: _isSavingLocally,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: AppWidgets.primaryButton(
                      text: 'Lưu và đăng tải',
                      onPressed: () => _saveToVocabulary(shouldShare: true),
                      enabled: !_isSavingLocally && !_isSavingAndSharing,
                      isLoading: _isSavingAndSharing,
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
