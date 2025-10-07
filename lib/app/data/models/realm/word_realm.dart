import 'package:realm/realm.dart';

part 'word_realm.g.dart';

@RealmModel()
class _Word {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;

  late String headword;
  late String normalizedHeadword;
  String? ipa;
  String? pos;
  late String meaningVi;
  String? exampleEn;
  String? exampleVi;
  String? audioUrl;
  String? imageUrl;
  late String createdBy = 'system';
  late DateTime createdAt;
  DateTime? lastSyncedAt;
}