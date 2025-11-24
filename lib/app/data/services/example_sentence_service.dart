import 'dart:convert';

class ExampleSentencePair {
  const ExampleSentencePair({
    required this.english,
    required this.vietnamese,
  });

  final String english;
  final String vietnamese;

  bool get hasEnglish => english.trim().isNotEmpty;
  bool get hasVietnamese => vietnamese.trim().isNotEmpty;
}

class ExampleSentenceService {
  static const _examplesTagKey = 'examples';
  static const _examplesEnKey = 'en';
  static const _examplesViKey = 'vi';

  static ExampleSentencePair resolveForVocabulary({
    required String word,
    String? translation,
    String? definition,
    String? category,
    String? example,
    String? tags,
    String? topicOverride,
    int? seed,
  }) {
    final normalizedTranslation =
        _clean(translation) ?? _clean(definition) ?? word;

    final existingVi = extractVietnameseExample(tags);
    final pair = resolve(
      word: word,
      translation: normalizedTranslation,
      topic: topicOverride ?? category,
      englishExample: example,
      vietnameseExample: existingVi,
      seed: seed ?? word.hashCode,
    );

    return pair;
  }

  static ExampleSentencePair resolve({
    required String word,
    required String translation,
    String? topic,
    String? englishExample,
    String? vietnameseExample,
    int? seed,
  }) {
    final cleanedEn = _clean(englishExample);
    final cleanedVi = _clean(vietnameseExample);
    if (cleanedEn != null && cleanedVi != null) {
      return ExampleSentencePair(english: cleanedEn, vietnamese: cleanedVi);
    }

    final generated = generate(
      word: word,
      translation: translation,
      topic: topic,
      seed: seed,
    );

    return ExampleSentencePair(
      english: cleanedEn ?? generated.english,
      vietnamese: cleanedVi ?? generated.vietnamese,
    );
  }

  static ExampleSentencePair generate({
    required String word,
    required String translation,
    String? topic,
    int? seed,
  }) {
    final normalizedTranslation =
        translation.trim().isEmpty ? word : translation.trim();
    final topicTemplate = _matchTemplate(topic);
    final templateSeed = seed ?? word.hashCode;
    final englishTemplate = topicTemplate.englishTemplates[
        _pickIndex(topicTemplate.englishTemplates.length, templateSeed)];
    final vietnameseTemplate = topicTemplate.vietnameseTemplates[
        _pickIndex(topicTemplate.vietnameseTemplates.length, templateSeed + 1)];

    final articleWord = _withArticle(word);
    final capitalizedWord = _capitalize(word);
    final translationWithArticle = _vietnameseWithArticle(normalizedTranslation);
    final capitalizedTranslation = _capitalize(normalizedTranslation);

    final replacements = <String, String>{
      '{word}': word,
      '{Word}': capitalizedWord,
      '{article_word}': articleWord,
      '{translation}': normalizedTranslation,
      '{Translation}': capitalizedTranslation,
      '{translation_with_article}': translationWithArticle,
      '{topic}': topicTemplate.topicLabel ?? (topic ?? ''),
    };

    String compose(String template) {
      var result = template;
      replacements.forEach((key, value) {
        result = result.replaceAll(key, value);
      });
      return result;
    }

    return ExampleSentencePair(
      english: compose(englishTemplate),
      vietnamese: compose(vietnameseTemplate),
    );
  }

  static String mergeExamplesIntoTags(
    String? currentTags,
    ExampleSentencePair pair, {
    bool overrideEnglish = false,
    bool overrideVietnamese = false,
  }) {
    final map = _decodeTagMap(currentTags);
    final existing = map[_examplesTagKey];
    final examples = <String, dynamic>{
      if (existing is Map<String, dynamic>) ...existing,
    };

    final currentEn = _clean(examples[_examplesEnKey] as String?);
    final currentVi = _clean(examples[_examplesViKey] as String?);

    if (overrideEnglish || currentEn == null) {
      examples[_examplesEnKey] = pair.english;
    }
    if (overrideVietnamese || currentVi == null) {
      examples[_examplesViKey] = pair.vietnamese;
    }

    if (examples.isEmpty) {
      map.remove(_examplesTagKey);
    } else {
      map[_examplesTagKey] = examples;
    }

    if (map.isEmpty) {
      return '';
    }

    return jsonEncode(map);
  }

  static String? extractVietnameseExample(String? tags) {
    final map = _decodeTagMap(tags);
    final examples = map[_examplesTagKey];
    if (examples is Map<String, dynamic>) {
      final value = examples[_examplesViKey];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }

    final legacyValue = map[_examplesViKey];
    if (legacyValue is String && legacyValue.trim().isNotEmpty) {
      return legacyValue.trim();
    }
    return null;
  }

  static Map<String, dynamic> _decodeTagMap(String? tags) {
    if (tags == null) {
      return <String, dynamic>{};
    }
    final trimmed = tags.trim();
    if (trimmed.isEmpty) {
      return <String, dynamic>{};
    }
    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is Map<String, dynamic>) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (_) {
      // Attempt key=value fallback parsing
      final map = <String, dynamic>{};
      final parts = trimmed.split(';');
      for (final part in parts) {
        final section = part.trim();
        if (section.isEmpty) continue;
        final separatorIndex = section.indexOf('=');
        if (separatorIndex <= 0 || separatorIndex >= section.length - 1) {
          continue;
        }
        final key = section.substring(0, separatorIndex).trim();
        final value = section.substring(separatorIndex + 1).trim();
        if (key.isEmpty) continue;
        map[key] = Uri.decodeComponent(value);
      }
      if (map.isNotEmpty) {
        return map;
      }
    }
    return <String, dynamic>{};
  }

  static int _pickIndex(int length, int seed) {
    if (length <= 0) return 0;
    final positive = seed & 0x7fffffff;
    return positive % length;
  }

  static String? _clean(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static String _capitalize(String value) {
    if (value.isEmpty) return value;
    if (value.length == 1) {
      return value.toUpperCase();
    }
    return value[0].toUpperCase() + value.substring(1);
  }

  static String _withArticle(String word) {
    if (word.isEmpty) return word;
    final firstLetter = word[0].toLowerCase();
    const vowels = {'a', 'e', 'i', 'o', 'u'};
    final needsArticle =
        RegExp(r'^[a-zA-Z]').hasMatch(word) && word.split(' ').length == 1;
    if (!needsArticle) return word;
    final article = vowels.contains(firstLetter) ? 'an' : 'a';
    return '$article $word';
  }

  static String _vietnameseWithArticle(String phrase) {
    final lower = phrase.toLowerCase();
    const prefixes = [
      'một ',
      'con ',
      'cái ',
      'chiếc ',
      'người ',
      'loài ',
      'những ',
      'các ',
      'một chiếc ',
      'một con ',
      'một cái ',
    ];
    for (final prefix in prefixes) {
      if (lower.startsWith(prefix)) {
        return phrase;
      }
    }
    return 'một $phrase';
  }

  static _TopicTemplate _matchTemplate(String? topic) {
    if (topic == null || topic.trim().isEmpty) {
      return _defaultTemplate;
    }
    final normalized = topic.toLowerCase();
    for (final template in _topicTemplates) {
      if (template.keywords.any((keyword) => normalized.contains(keyword))) {
        return template;
      }
    }
    return _defaultTemplate;
  }
}

class _TopicTemplate {
  const _TopicTemplate({
    required this.keywords,
    required this.englishTemplates,
    required this.vietnameseTemplates,
    this.topicLabel,
  });

  final List<String> keywords;
  final List<String> englishTemplates;
  final List<String> vietnameseTemplates;
  final String? topicLabel;
}

const _defaultTemplate = _TopicTemplate(
  keywords: [],
  topicLabel: 'everyday life',
  englishTemplates: [
    'I used the word "{word}" while talking about {topic}.',
    '{Word} is a word I want to remember for daily conversations.',
    'Learning "{word}" helps me express myself in {topic}.',
  ],
  vietnameseTemplates: [
    'Tôi đã dùng từ "{translation}" khi trò chuyện về {topic}.',
    '{Translation} là từ tôi muốn ghi nhớ cho các cuộc trò chuyện hằng ngày.',
    'Học từ "{translation}" giúp tôi diễn đạt tốt hơn trong cuộc sống.',
  ],
);

const _topicTemplates = [
  _TopicTemplate(
    keywords: [
      'động vật',
      'thú',
      'animal',
      'wildlife',
      'thế giới động vật',
      'đời sống hoang dã',
    ],
    topicLabel: 'wildlife',
    englishTemplates: [
      'We saw {article_word} at the zoo and learned it is called "{word}".',
      '{Word} lives in the wild and always fascinates me.',
      'The wildlife documentary showed how {article_word} survives.',
    ],
    vietnameseTemplates: [
      'Chúng tôi nhìn thấy {translation_with_article} ở sở thú và nhớ tên tiếng Anh là "{word}".',
      '{Translation} là loài động vật hoang dã khiến tôi rất thích thú.',
      'Bộ phim về thiên nhiên cho tôi thấy {translation_with_article} sinh tồn ra sao.',
    ],
  ),
  _TopicTemplate(
    keywords: [
      'công nghệ',
      'technology',
      'thiết bị',
      'kỹ thuật số',
      'kỹ thuật',
      'computer',
      'tech',
    ],
    topicLabel: 'technology',
    englishTemplates: [
      'Modern technology often relies on {word} to work smoothly.',
      'I use {word} every day when dealing with digital tools.',
      '{Word} makes my study and work much more efficient.',
    ],
    vietnameseTemplates: [
      'Công nghệ hiện đại thường dựa vào {translation} để hoạt động trơn tru.',
      'Tôi dùng {translation_with_article} mỗi ngày khi làm việc với thiết bị số.',
      '{Translation} giúp việc học và làm của tôi hiệu quả hơn nhiều.',
    ],
  ),
  _TopicTemplate(
    keywords: [
      'ẩm thực',
      'food',
      'ăn uống',
      'nấu ăn',
      'cooking',
      'món ăn',
      'ẩm thực việt',
    ],
    topicLabel: 'food',
    englishTemplates: [
      'We ordered {article_word} at the restaurant and enjoyed the taste.',
      'Cooking class today taught us how to make {article_word}.',
      '{Word} is a dish I love to share with friends.',
    ],
    vietnameseTemplates: [
      'Chúng tôi gọi {translation_with_article} ở nhà hàng và rất thích hương vị.',
      'Lớp học nấu ăn hôm nay dạy cách làm {translation}.',
      '{Translation} là món tôi rất thích chia sẻ với bạn bè.',
    ],
  ),
  _TopicTemplate(
    keywords: [
      'du lịch',
      'travel',
      'địa điểm',
      'kỳ nghỉ',
      'holiday',
      'tour',
    ],
    topicLabel: 'travel',
    englishTemplates: [
      'During our trip, we discovered {article_word} at a local market.',
      'Travel guides recommend learning the word "{word}" before visiting.',
      'I noted down "{word}" to use when planning my next journey.',
    ],
    vietnameseTemplates: [
      'Trong chuyến đi, chúng tôi tìm thấy {translation_with_article} ở chợ địa phương.',
      'Các hướng dẫn du lịch khuyên nên học từ "{word}" trước khi ghé thăm.',
      'Tôi ghi lại từ "{translation}" để dùng khi chuẩn bị chuyến đi tiếp theo.',
    ],
  ),
  _TopicTemplate(
    keywords: [
      'giáo dục',
      'học tập',
      'study',
      'school',
      'ôn tập',
      'lớp học',
    ],
    topicLabel: 'education',
    englishTemplates: [
      'In class we practiced using the word "{word}" in a sentence.',
      'Studying new vocabulary like "{word}" makes learning fun.',
      '{Word} is a key term in our lesson this week.',
    ],
    vietnameseTemplates: [
      'Trong lớp, chúng tôi luyện đặt câu với từ "{translation}".',
      'Học từ mới như "{translation}" khiến việc học thú vị hơn.',
      '{Translation} là thuật ngữ quan trọng trong bài học tuần này.',
    ],
  ),
  _TopicTemplate(
    keywords: [
      'thể thao',
      'sports',
      'exercise',
      'fitness',
      'game',
      'match',
    ],
    topicLabel: 'sports',
    englishTemplates: [
      'The coach explained how to use the word "{word}" during practice.',
      'Fans shouted "{word}" while watching the exciting match.',
      '{Word} is essential when talking about this sport.',
    ],
    vietnameseTemplates: [
      'Huấn luyện viên giải thích cách dùng từ "{translation}" trong buổi tập.',
      'Người hâm mộ hô vang "{translation}" khi xem trận đấu sôi nổi.',
      '{Translation} là từ không thể thiếu khi nói về môn thể thao này.',
    ],
  ),
  _TopicTemplate(
    keywords: [
      'y tế',
      'sức khỏe',
      'health',
      'medical',
      'bệnh viện',
      'chăm sóc',
    ],
    topicLabel: 'healthcare',
    englishTemplates: [
      'Doctors often mention "{word}" when discussing treatment.',
      'Understanding "{word}" helps me talk about health issues.',
      '{Word} appeared in the article about healthy living.',
    ],
    vietnameseTemplates: [
      'Các bác sĩ thường nhắc đến "{translation}" khi nói về điều trị.',
      'Hiểu được "{translation}" giúp tôi nói về các vấn đề sức khỏe.',
      'Bài viết về sống khỏe đã đề cập đến "{translation}".',
    ],
  ),
  _TopicTemplate(
    keywords: [
      'gia đình',
      'family',
      'home',
      'đời sống',
      'daily',
      'household',
    ],
    topicLabel: 'family life',
    englishTemplates: [
      'My family uses the word "{word}" when we talk at home.',
      '{Word} reminds me of warm moments with my loved ones.',
      'We learned "{word}" while sharing stories about family life.',
    ],
    vietnameseTemplates: [
      'Gia đình tôi thường dùng từ "{translation}" khi trò chuyện ở nhà.',
      '{Translation} gợi tôi nhớ đến những khoảnh khắc ấm áp bên người thân.',
      'Chúng tôi học từ "{translation}" khi kể những câu chuyện gia đình.',
    ],
  ),
];
