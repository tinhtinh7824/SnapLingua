import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of reports made against posts.
class FirestorePostReport {
  FirestorePostReport({
    required this.reportId,
    required this.postId,
    required this.reporterId,
    required this.reason,
    this.details,
    required this.status,
    this.handledBy,
    this.handledAt,
    required this.createdAt,
  });

  final String reportId;
  final String postId;
  final String reporterId;
  final String reason;
  final String? details;
  final String status;
  final String? handledBy;
  final DateTime? handledAt;
  final DateTime createdAt;

  factory FirestorePostReport.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Post report document ${doc.id} is missing data.');
    }

    return FirestorePostReport(
      reportId: doc.id,
      postId: (data['post_id'] as String?) ?? '',
      reporterId: (data['reporter_id'] as String?) ?? '',
      reason: (data['reason'] as String?) ?? '',
      details: data['details'] as String?,
      status: (data['status'] as String?) ?? 'open',
      handledBy: data['handled_by'] as String?,
      handledAt:
          data['handled_at'] != null ? _asDateTime(data['handled_at']) : null,
      createdAt: _asDateTime(data['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'post_id': postId,
      'reporter_id': reporterId,
      'reason': reason,
      'details': details,
      'status': status,
      'handled_by': handledBy,
      'handled_at': handledAt != null ? Timestamp.fromDate(handledAt!) : null,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  FirestorePostReport copyWith({
    String? postId,
    String? reporterId,
    String? reason,
    String? details,
    String? status,
    String? handledBy,
    DateTime? handledAt,
    DateTime? createdAt,
  }) {
    return FirestorePostReport(
      reportId: reportId,
      postId: postId ?? this.postId,
      reporterId: reporterId ?? this.reporterId,
      reason: reason ?? this.reason,
      details: details ?? this.details,
      status: status ?? this.status,
      handledBy: handledBy ?? this.handledBy,
      handledAt: handledAt ?? this.handledAt,
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
