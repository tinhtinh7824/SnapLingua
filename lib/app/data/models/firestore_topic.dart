import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of a topic.
class FirestoreTopic {
  FirestoreTopic({
    required this.topicId,
    required this.name,
    this.icon,
    this.ownerId,
    required this.visibility,
    required this.createdAt,
    List<String>? dictionaryWordIds,
  }) : dictionaryWordIds = dictionaryWordIds ?? const [];

  final String topicId;
  final String name;
  final String? icon;
  final String? ownerId;
  final String visibility;
  final DateTime createdAt;
  final List<String> dictionaryWordIds;

  factory FirestoreTopic.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Topic document ${doc.id} is missing data.');
    }

    return FirestoreTopic(
      topicId: doc.id,
      name: (data['name'] as String?) ?? '',
      icon: data['icon'] as String?,
      ownerId: data['owner_id'] as String?,
      visibility: (data['visibility'] as String?) ?? 'public',
      createdAt: _asDateTime(data['created_at']),
      dictionaryWordIds: (data['dictionary_word_ids'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': icon,
      'owner_id': ownerId,
      'visibility': visibility,
      'created_at': Timestamp.fromDate(createdAt),
      'dictionary_word_ids': dictionaryWordIds,
    };
  }

  FirestoreTopic copyWith({
    String? name,
    String? icon,
    String? ownerId,
    String? visibility,
    DateTime? createdAt,
    List<String>? dictionaryWordIds,
  }) {
    return FirestoreTopic(
      topicId: topicId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      ownerId: ownerId ?? this.ownerId,
      visibility: visibility ?? this.visibility,
      createdAt: createdAt ?? this.createdAt,
      dictionaryWordIds: dictionaryWordIds ?? this.dictionaryWordIds,
    );
  }

  static DateTime _asDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(value.toInt());
    }
    throw StateError('Unsupported timestamp value: $value');
  }
}
