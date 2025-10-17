import 'package:get/get.dart';

class CommunityPost {
  CommunityPost({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.postedAt,
    required this.imageUrl,
    required this.detectedLabel,
    required this.confidence,
    required this.headword,
    required this.phonetic,
    required this.translation,
    required this.likes,
    required this.comments,
    required this.bookmarks,
    this.topic,
  });

  final String id;
  final String authorName;
  final String authorAvatar;
  final String postedAt;
  final String imageUrl;
  final String detectedLabel;
  final double confidence;
  final String headword;
  final String phonetic;
  final String translation;
  final int likes;
  final int comments;
  final int bookmarks;
  final String? topic;
}

class CommunityController extends GetxController {
  final RxList<CommunityPost> posts = <CommunityPost>[].obs;

  @override
  void onInit() {
    super.onInit();
    posts.assignAll(_mockPosts);
  }

  List<CommunityPost> get _mockPosts => [
        CommunityPost(
          id: '1',
          authorName: 'Phúc Lê',
          authorAvatar:
              'https://i.pravatar.cc/150?img=12', // placeholder avatar
          postedAt: '10 phút trước',
          imageUrl:
              'https://images.unsplash.com/photo-1508672019048-805c876b67e2?auto=format&fit=crop&w=800&q=80',
          detectedLabel: 'giraffe',
          confidence: 0.96,
          headword: 'giraffe',
          phonetic: '/dʒəˈræf/',
          translation: 'hươu cao cổ',
          likes: 90,
          comments: 3,
          bookmarks: 10,
          topic: 'Động vật hoang dã',
        ),
        CommunityPost(
          id: '2',
          authorName: 'Minh Châu',
          authorAvatar: 'https://i.pravatar.cc/150?img=47',
          postedAt: '30 phút trước',
          imageUrl:
              'https://images.unsplash.com/photo-1526336024174-e58f5cdd8e13?auto=format&fit=crop&w=800&q=80',
          detectedLabel: 'zebra',
          confidence: 0.91,
          headword: 'zebra',
          phonetic: '/ˈziː.brə/',
          translation: 'ngựa vằn',
          likes: 75,
          comments: 5,
          bookmarks: 18,
          topic: 'Thế giới động vật',
        ),
      ];
}
