import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of normalized photos.
class FirestorePhoto {
  FirestorePhoto({
    required this.photoId,
    this.userId,
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.format,
    this.sizeBytes,
    required this.source,
    this.takenAt,
    required this.uploadedAt,
    this.exif,
    this.checksumSha256,
  });

  final String photoId;
  final String? userId;
  final String imageUrl;
  final int width;
  final int height;
  final String format;
  final int? sizeBytes;
  final String source;
  final DateTime? takenAt;
  final DateTime uploadedAt;
  final Map<String, dynamic>? exif;
  final String? checksumSha256;

  factory FirestorePhoto.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Photo document ${doc.id} is missing data.');
    }

    return FirestorePhoto(
      photoId: doc.id,
      userId: data['user_id'] as String?,
      imageUrl: (data['image_url'] as String?) ?? '',
      width: (data['width'] as num?)?.toInt() ?? 0,
      height: (data['height'] as num?)?.toInt() ?? 0,
      format: (data['format'] as String?) ?? '',
      sizeBytes: (data['size_bytes'] as num?)?.toInt(),
      source: (data['source'] as String?) ?? '',
      takenAt:
          data['taken_at'] != null ? _asDateTime(data['taken_at']) : null,
      uploadedAt: _asDateTime(data['uploaded_at']),
      exif: (data['exif'] as Map<String, dynamic>?),
      checksumSha256: data['checksum_sha256'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'image_url': imageUrl,
      'width': width,
      'height': height,
      'format': format,
      'size_bytes': sizeBytes,
      'source': source,
      'taken_at': takenAt != null ? Timestamp.fromDate(takenAt!) : null,
      'uploaded_at': Timestamp.fromDate(uploadedAt),
      'exif': exif,
      'checksum_sha256': checksumSha256,
    };
  }

  FirestorePhoto copyWith({
    String? userId,
    String? imageUrl,
    int? width,
    int? height,
    String? format,
    int? sizeBytes,
    String? source,
    DateTime? takenAt,
    DateTime? uploadedAt,
    Map<String, dynamic>? exif,
    String? checksumSha256,
  }) {
    return FirestorePhoto(
      photoId: photoId,
      userId: userId ?? this.userId,
      imageUrl: imageUrl ?? this.imageUrl,
      width: width ?? this.width,
      height: height ?? this.height,
      format: format ?? this.format,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      source: source ?? this.source,
      takenAt: takenAt ?? this.takenAt,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      exif: exif ?? this.exif,
      checksumSha256: checksumSha256 ?? this.checksumSha256,
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
