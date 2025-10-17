import 'package:realm/realm.dart';

part 'post_realm.realm.dart';

@RealmModel()
class _Post {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;

  // Author reference
  late String authorId;
  String? authorName;
  String? authorAvatarUrl;

  // Group reference (optional)
  String? groupId;

  // Content
  late String content;
  String? imageUrl;

  // Engagement
  late List<String> likedByUserIds = const [];
  late int likeCount = 0;
  late int commentCount = 0;

  // Metadata
  late DateTime createdAt;
  DateTime? updatedAt;
  DateTime? lastSyncedAt;

  // Offline tracking
  late bool needsSync = false;
}
