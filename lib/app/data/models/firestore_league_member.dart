import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore representation of a user's standing within a league cycle.
class FirestoreLeagueMember {
  FirestoreLeagueMember({
    required this.id,
    required this.cycleId,
    required this.userId,
    required this.weeklyXp,
    this.rank,
    this.promoted,
    this.demoted,
    this.isVirtual = false,
    this.virtualIndex,
  });

  final String id;
  final String cycleId;
  final String userId;
  final int weeklyXp;
  final int? rank;
  final bool? promoted;
  final bool? demoted;
  final bool isVirtual;
  final int? virtualIndex;

  factory FirestoreLeagueMember.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('League member document ${doc.id} is missing data.');
    }

    return FirestoreLeagueMember(
      id: doc.id,
      cycleId: (data['cycle_id'] as String?) ?? '',
      userId: (data['user_id'] as String?) ?? '',
      weeklyXp: (data['weekly_xp'] as num?)?.toInt() ?? 0,
      rank: (data['rank'] as num?)?.toInt(),
      promoted: data['promoted'] as bool?,
      demoted: data['demoted'] as bool?,
      isVirtual: data['is_virtual'] as bool? ?? false,
      virtualIndex: (data['virtual_index'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cycle_id': cycleId,
      'user_id': userId,
      'weekly_xp': weeklyXp,
      'rank': rank,
      'promoted': promoted,
      'demoted': demoted,
      'is_virtual': isVirtual,
      if (virtualIndex != null) 'virtual_index': virtualIndex,
    };
  }

  FirestoreLeagueMember copyWith({
    String? cycleId,
    String? userId,
    int? weeklyXp,
    int? rank,
    bool? promoted,
    bool? demoted,
    bool? isVirtual,
    int? virtualIndex,
  }) {
    return FirestoreLeagueMember(
      id: id,
      cycleId: cycleId ?? this.cycleId,
      userId: userId ?? this.userId,
      weeklyXp: weeklyXp ?? this.weeklyXp,
      rank: rank ?? this.rank,
      promoted: promoted ?? this.promoted,
      demoted: demoted ?? this.demoted,
      isVirtual: isVirtual ?? this.isVirtual,
      virtualIndex: virtualIndex ?? this.virtualIndex,
    );
  }
}
