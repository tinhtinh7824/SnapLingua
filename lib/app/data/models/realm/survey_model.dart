import 'package:realm/realm.dart';

part 'survey_model.realm.dart';

@RealmModel()
class _SurveyResponse {
  @PrimaryKey()
  late String id;

  late String userId;
  late String? name;
  late String? gender;
  late String? birthDay;
  late String? birthMonth;
  late String? birthYear;
  late String? purpose;
  late String? studyTime;
  late DateTime completedAt;
  late DateTime createdAt;
  late DateTime? updatedAt;
}