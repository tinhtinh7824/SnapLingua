import 'package:realm/realm.dart';

part 'group_realm.realm.dart';

@RealmModel()
class _Group {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;

  // Group info
  late String name;
  String? description;
  String? avatarUrl;
  String? coverImageUrl;

  // Members
  late String ownerId;
  late List<String> memberIds = const [];
  late List<String> adminIds = const [];
  late int memberCount = 0;

  // Settings
  late String visibility = 'public'; // public, private
  late String joinType = 'open'; // open, approval_required, invite_only
  late bool allowMemberPosts = true;

  // Stats
  late int postCount = 0;
  late int activeThisWeek = 0;

  // Metadata
  late DateTime createdAt;
  DateTime? updatedAt;
  DateTime? lastSyncedAt;

  // Offline tracking
  late bool needsSync = false;
}
