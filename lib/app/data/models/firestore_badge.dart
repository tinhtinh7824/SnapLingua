import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of recognition badges/stickers.
class FirestoreBadge {
  FirestoreBadge({
    required this.badgeId,
    required this.code,
    required this.name,
    this.iconUrl,
    required this.stickerUrl,
    required this.stickerAnimated,
    this.description,
    required this.conditionType,
    required this.threshold,
    required this.createdAt,
  });

  final String badgeId;
  final String code;
  final String name;
  final String? iconUrl;
  final String stickerUrl;
  final bool stickerAnimated;
  final String? description;
  final String conditionType;
  final int threshold;
  final DateTime createdAt;

  factory FirestoreBadge.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Badge document ${doc.id} is missing data.');
    }

    return FirestoreBadge(
      badgeId: doc.id,
      code: (data['code'] as String?) ?? '',
      name: (data['name'] as String?) ?? '',
      iconUrl: data['icon_url'] as String?,
      stickerUrl: (data['sticker_url'] as String?) ?? '',
      stickerAnimated: (data['sticker_animated'] as bool?) ?? false,
      description: data['description'] as String?,
      conditionType: (data['condition_type'] as String?) ?? '',
      threshold: (data['threshold'] as num?)?.toInt() ?? 0,
      createdAt: _asDateTime(data['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'icon_url': iconUrl,
      'sticker_url': stickerUrl,
      'sticker_animated': stickerAnimated,
      'description': description,
      'condition_type': conditionType,
      'threshold': threshold,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  FirestoreBadge copyWith({
    String? code,
    String? name,
    String? iconUrl,
    String? stickerUrl,
    bool? stickerAnimated,
    String? description,
    String? conditionType,
    int? threshold,
    DateTime? createdAt,
  }) {
    return FirestoreBadge(
      badgeId: badgeId,
      code: code ?? this.code,
      name: name ?? this.name,
      iconUrl: iconUrl ?? this.iconUrl,
      stickerUrl: stickerUrl ?? this.stickerUrl,
      stickerAnimated: stickerAnimated ?? this.stickerAnimated,
      description: description ?? this.description,
      conditionType: conditionType ?? this.conditionType,
      threshold: threshold ?? this.threshold,
      createdAt: createdAt ?? this.createdAt,
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
