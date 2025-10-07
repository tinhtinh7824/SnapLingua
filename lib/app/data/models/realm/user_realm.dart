import 'package:realm/realm.dart';

part 'user_realm.g.dart';

@RealmModel()
class _User {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;

  String? email;
  String? displayName;
  String? avatarUrl;
  late String role = 'user';
  late String status = 'active';
  late DateTime createdAt;
  DateTime? updatedAt;

  // Realm Auth ID for sync
  String? realmUserId;
}