import 'package:realm/realm.dart';

part 'user_model.realm.dart';

@RealmModel()
class _User {
  @PrimaryKey()
  late String userId;

  late String? email;
  late String? displayName;
  late String? avatarUrl;
  late String role;
  late String status;
  late DateTime createdAt;
  late DateTime? updatedAt;
}
