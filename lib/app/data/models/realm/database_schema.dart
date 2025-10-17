import 'package:realm/realm.dart';

part 'database_schema.realm.dart';

/// Core user profile referenced across the domain.
@RealmModel()
class _DbUser {
  @PrimaryKey()
  @MapTo('user_id')
  late String userId;

  String? email;

  @MapTo('display_name')
  String? displayName;

  @MapTo('avatar_url')
  String? avatarUrl;

  late String role; // user | admin

  late String status; // active | blocked | deleted

  @MapTo('created_at')
  late DateTime createdAt;

  @MapTo('updated_at')
  DateTime? updatedAt;
}

/// Linked authentication providers such as Google/Facebook/password.
@RealmModel()
class _AuthProviderEntity {
  @PrimaryKey()
  @MapTo('provider_id')
  late String providerId;

  @MapTo('user_id')
  late String userId;

  late String provider; // password | google | facebook

  @MapTo('provider_uid')
  late String providerUid;

  @MapTo('email_verified')
  late bool emailVerified;

  @MapTo('linked_at')
  late DateTime linkedAt;
}

/// Security configuration per user (password + 2FA).
@RealmModel()
class _UserSecurityEntity {
  @PrimaryKey()
  @MapTo('user_id')
  late String userId;

  @MapTo('password_hash')
  String? passwordHash;

  @MapTo('two_factor_enabled')
  late bool twoFactorEnabled;

  @MapTo('two_factor_method')
  String? twoFactorMethod; // app | email

  @MapTo('two_factor_secret')
  String? twoFactorSecret;

  @MapTo('last_password_change')
  DateTime? lastPasswordChange;
}

/// Registered device tokens for push notifications.
@RealmModel()
class _DeviceTokenEntity {
  @PrimaryKey()
  @MapTo('token_id')
  late String tokenId;

  @MapTo('user_id')
  late String userId;

  @MapTo('device_type')
  late String deviceType; // android | ios

  @MapTo('device_id')
  String? deviceId;

  @MapTo('fcm_token')
  late String fcmToken;

  @MapTo('last_active_at')
  DateTime? lastActiveAt;

  @MapTo('created_at')
  late DateTime createdAt;
}

/// Badge catalogue shared by achievements and community features.
@RealmModel()
class _BadgeEntity {
  @PrimaryKey()
  @MapTo('badge_id')
  late String badgeId;

  late String code;

  late String name;

  @MapTo('icon_url')
  String? iconUrl;

  @MapTo('sticker_url')
  late String stickerUrl;

  @MapTo('sticker_animated')
  late bool stickerAnimated;

  String? description;

  @MapTo('condition_type')
  late String conditionType; // words_learned, streak, weekly_xp, ...

  late int threshold;

  @MapTo('created_at')
  late DateTime createdAt;
}

/// Pivot of users who earned a badge.
@RealmModel()
class _UserBadgeEntity {
  @PrimaryKey()
  late String id;

  @MapTo('user_id')
  late String userId;

  @MapTo('badge_id')
  late String badgeId;

  @MapTo('awarded_at')
  late DateTime awardedAt;
}

/// Canonical photo assets captured or uploaded by the user.
@RealmModel()
class _PhotoEntity {
  @PrimaryKey()
  @MapTo('photo_id')
  late String photoId;

  @MapTo('user_id')
  String? userId;

  @MapTo('image_url')
  late String imageUrl;

  late int width;

  late int height;

  late String format; // jpg, jpeg, png, webp

  @MapTo('size_bytes')
  int? sizeBytes;

  late String source; // camera | gallery

  @MapTo('taken_at')
  DateTime? takenAt;

  @MapTo('uploaded_at')
  late DateTime uploadedAt;

  /// JSON metadata extracted from EXIF (stored as stringified JSON).
  String? exif;

  @MapTo('checksum_sha256')
  String? checksumSha256;
}

/// Detection batch result per photo/model run.
@RealmModel()
class _DetectionEntity {
  @PrimaryKey()
  @MapTo('detection_id')
  late String detectionId;

  @MapTo('photo_id')
  late String photoId;

  @MapTo('model_version')
  late String modelVersion;

  @MapTo('result_json')
  late String resultJson; // Raw detection payload

  @MapTo('created_at')
  late DateTime createdAt;
}

/// Flattened detection → vocabulary mapping entries.
@RealmModel()
class _DetectionWordEntity {
  @PrimaryKey()
  late String id;

  @MapTo('detection_id')
  late String detectionId;

  late String label;

  late int confidence; // 0 – 1000

  @MapTo('mapped_word_id')
  String? mappedWordId;

  String? bbox; // JSON string

  late bool selected;

  @MapTo('created_at')
  late DateTime createdAt;
}

/// Core dictionary entries shared across users.
@RealmModel()
class _DictionaryWordEntity {
  @PrimaryKey()
  @MapTo('word_id')
  late String wordId;

  late String headword;

  @MapTo('normalized_headword')
  late String normalizedHeadword;

  String? ipa;

  String? pos;

  @MapTo('meaning_vi')
  late String meaningVi;

  @MapTo('example_en')
  String? exampleEn;

  @MapTo('example_vi')
  String? exampleVi;

  @MapTo('audio_url')
  String? audioUrl;

  @MapTo('image_url')
  String? imageUrl;

  @MapTo('created_by')
  late String createdBy; // system | user

  @MapTo('created_at')
  late DateTime createdAt;
}

/// Personalized vocabulary state per learner.
@RealmModel()
class _PersonalWordEntity {
  @PrimaryKey()
  @MapTo('personal_word_id')
  late String personalWordId;

  @MapTo('user_id')
  late String userId;

  @MapTo('word_id')
  String? wordId;

  @MapTo('custom_headword')
  String? customHeadword;

  @MapTo('custom_ipa')
  String? customIpa;

  @MapTo('custom_meaning_vi')
  String? customMeaningVi;

  late String status; // learning | learned | archived

  late String source; // camera | manual | community | import

  @MapTo('source_photo_id')
  String? sourcePhotoId;

  @MapTo('srs_stage')
  late int srsStage;

  @MapTo('srs_ease')
  late int srsEase;

  @MapTo('srs_interval_days')
  late int srsIntervalDays;

  @MapTo('srs_due_at')
  late DateTime srsDueAt;

  late int repetitions;

  @MapTo('wrong_streak')
  late int wrongStreak;

  @MapTo('forget_count')
  late int forgetCount;

  @MapTo('last_reviewed_at')
  DateTime? lastReviewedAt;

  @MapTo('created_at')
  late DateTime createdAt;
}

/// Thematic groupings for personalized vocabulary.
@RealmModel()
class _TopicEntity {
  @PrimaryKey()
  @MapTo('topic_id')
  late String topicId;

  late String name;

  String? icon;

  @MapTo('owner_id')
  String? ownerId;

  late String visibility; // public | private

  @MapTo('created_at')
  late DateTime createdAt;
}

/// Join table tracking topic assignments per personal word.
@RealmModel()
class _PersonalWordTopicEntity {
  @PrimaryKey()
  late String id;

  @MapTo('personal_word_id')
  late String personalWordId;

  @MapTo('topic_id')
  late String topicId;

  @MapTo('is_primary')
  late bool isPrimary;

  @MapTo('created_at')
  late DateTime createdAt;
}

/// History of merged dictionary entries to prevent duplicates.
@RealmModel()
class _WordMergeEntity {
  @PrimaryKey()
  @MapTo('merge_id')
  late String mergeId;

  @MapTo('source_word_id')
  late String sourceWordId;

  @MapTo('target_word_id')
  late String targetWordId;

  String? reason;

  @MapTo('merged_at')
  late DateTime mergedAt;
}

/// Sessions that drive spaced-repetition learning.
@RealmModel()
class _StudySessionEntity {
  @PrimaryKey()
  @MapTo('session_id')
  late String sessionId;

  @MapTo('user_id')
  late String userId;

  late String type; // new | review

  @MapTo('planned_count')
  late int plannedCount;

  @MapTo('completed_count')
  late int completedCount;

  @MapTo('first_try_accuracy')
  int? firstTryAccuracy;

  @MapTo('started_at')
  late DateTime startedAt;

  @MapTo('ended_at')
  DateTime? endedAt;
}

/// Granular question results within a study session.
@RealmModel()
class _SessionItemEntity {
  @PrimaryKey()
  @MapTo('item_id')
  late String itemId;

  @MapTo('session_id')
  late String sessionId;

  @MapTo('personal_word_id')
  late String personalWordId;

  late int round;

  @MapTo('question_type')
  late String questionType; // flashcard | mcq | cloze | matching | listening

  @MapTo('first_try_correct')
  late bool firstTryCorrect;

  @MapTo('attempts_count')
  late int attemptsCount;

  int? score;

  /// Serialized payload for question/answer data.
  String? payload;

  @MapTo('created_at')
  late DateTime createdAt;
}

/// Daily aggregate KPIs per learner.
@RealmModel()
class _DailyProgressEntity {
  @PrimaryKey()
  @MapTo('progress_id')
  late String progressId;

  @MapTo('user_id')
  late String userId;

  @MapTo('date')
  late DateTime snapshotDate;

  @MapTo('new_target')
  late int newTarget;

  @MapTo('new_learned')
  late int newLearned;

  @MapTo('review_due')
  late int reviewDue;

  @MapTo('review_done')
  late int reviewDone;

  late int streak;

  @MapTo('xp_gained')
  late int xpGained;
}

/// User-level default goals and reminder configuration.
@RealmModel()
class _UserGoalEntity {
  @PrimaryKey()
  @MapTo('user_id')
  late String userId;

  @MapTo('daily_new_target')
  late int dailyNewTarget;

  late String tz;

  @MapTo('remind_morning')
  String? remindMorning;

  @MapTo('remind_evening')
  String? remindEvening;

  @MapTo('smart_remind')
  late bool smartRemind;
}

/// Community posts containing shared vocabulary or discussions.
@RealmModel()
class _PostEntity {
  @PrimaryKey()
  @MapTo('post_id')
  late String postId;

  @MapTo('user_id')
  late String userId;

  @MapTo('photo_url')
  String? photoUrl;

  String? caption;

  late String visibility; // public | friends | private

  late String status; // active | hidden

  @MapTo('created_at')
  late DateTime createdAt;
}

/// Snapshot vocabulary tied to a shareable post.
@RealmModel()
class _PostWordEntity {
  @PrimaryKey()
  late String id;

  @MapTo('post_id')
  late String postId;

  @MapTo('word_id')
  String? wordId;

  @MapTo('meaning_snapshot')
  late String meaningSnapshot;

  @MapTo('example_snapshot')
  String? exampleSnapshot;

  @MapTo('audio_url_snapshot')
  String? audioUrlSnapshot;
}

/// Post reactions (likes).
@RealmModel()
class _PostLikeEntity {
  @PrimaryKey()
  late String id;

  @MapTo('post_id')
  late String postId;

  @MapTo('user_id')
  late String userId;

  @MapTo('created_at')
  late DateTime createdAt;
}

/// Post discussion threads.
@RealmModel()
class _PostCommentEntity {
  @PrimaryKey()
  @MapTo('comment_id')
  late String commentId;

  @MapTo('post_id')
  late String postId;

  @MapTo('user_id')
  late String userId;

  @MapTo('comment_type')
  late String commentType; // text | sticker

  String? content;

  @MapTo('badge_id')
  String? badgeId;

  late String status; // active | hidden

  @MapTo('created_at')
  late DateTime createdAt;
}

/// Reports submitted against community content.
@RealmModel()
class _PostReportEntity {
  @PrimaryKey()
  @MapTo('report_id')
  late String reportId;

  @MapTo('post_id')
  late String postId;

  @MapTo('reporter_id')
  late String reporterId;

  late String reason; // spam, harmful, privacy, nudity, other

  String? details;

  late String status; // open | resolved | rejected

  @MapTo('handled_by')
  String? handledBy;

  @MapTo('handled_at')
  DateTime? handledAt;

  @MapTo('created_at')
  late DateTime createdAt;
}

/// Study group metadata.
@RealmModel()
class _GroupEntity {
  @PrimaryKey()
  @MapTo('group_id')
  late String groupId;

  late String name;

  @MapTo('require_approval')
  late bool requireApproval;

  String? description;

  @MapTo('created_by')
  late String createdBy;

  late String status; // active | archived

  @MapTo('created_at')
  late DateTime createdAt;
}

/// Membership state per group.
@RealmModel()
class _GroupMemberEntity {
  @PrimaryKey()
  late String id;

  @MapTo('group_id')
  late String groupId;

  @MapTo('user_id')
  late String userId;

  late String role; // owner | member

  late String status; // active | banned | pending

  @MapTo('joined_at')
  late DateTime joinedAt;
}

/// Chat/announcement payloads inside a group.
@RealmModel()
class _GroupMessageEntity {
  @PrimaryKey()
  @MapTo('message_id')
  late String messageId;

  @MapTo('group_id')
  late String groupId;

  @MapTo('user_id')
  late String userId;

  @MapTo('message_type')
  late String messageType; // text | sticker

  String? content;

  @MapTo('badge_id')
  String? badgeId;

  @MapTo('created_at')
  late DateTime createdAt;
}

/// Tier definitions for gamified leagues.
@RealmModel()
class _LeagueTierEntity {
  @PrimaryKey()
  @MapTo('tier_id')
  late String tierId;

  late String name;

  @MapTo('order_index')
  late int orderIndex;

  @MapTo('xp_cap_rule')
  String? xpCapRule;
}

/// Weekly cycle metadata by tier.
@RealmModel()
class _LeagueCycleEntity {
  @PrimaryKey()
  @MapTo('cycle_id')
  late String cycleId;

  @MapTo('tier_id')
  late String tierId;

  @MapTo('start_at')
  late DateTime startAt;

  @MapTo('end_at')
  late DateTime endAt;

  late String status; // running | closed
}

/// Aggregated league standings per cycle.
@RealmModel()
class _LeagueMemberEntity {
  @PrimaryKey()
  late String id;

  @MapTo('cycle_id')
  late String cycleId;

  @MapTo('user_id')
  late String userId;

  @MapTo('weekly_xp')
  late int weeklyXp;

  int? rank;

  late bool promoted;

  late bool demoted;
}

/// Accounting ledger for XP gains/spends.
@RealmModel()
class _XpTransactionEntity {
  @PrimaryKey()
  @MapTo('tx_id')
  late String txId;

  @MapTo('user_id')
  late String userId;

  @MapTo('source_type')
  late String sourceType; // learn_round, review, quest, community, ...

  @MapTo('source_id')
  String? sourceId;

  late int amount;

  String? note;

  @MapTo('created_at')
  late DateTime createdAt;
}

/// Shop catalogue items.
@RealmModel()
class _ItemEntity {
  @PrimaryKey()
  @MapTo('item_id')
  late String itemId;

  late String code;

  late String name;

  String? description;

  @MapTo('cost_scales')
  int? costScales;

  @MapTo('cost_gems')
  int? costGems;

  @MapTo('created_at')
  late DateTime createdAt;
}

/// Player inventory with optional expiry.
@RealmModel()
class _UserInventoryEntity {
  @PrimaryKey()
  late String id;

  @MapTo('user_id')
  late String userId;

  @MapTo('item_id')
  late String itemId;

  late int quantity;

  @MapTo('expires_at')
  DateTime? expiresAt;

  @MapTo('last_used_at')
  DateTime? lastUsedAt;
}

/// Notification delivery preferences per user.
@RealmModel()
class _NotificationSettingEntity {
  @PrimaryKey()
  @MapTo('user_id')
  late String userId;

  @MapTo('push_enabled')
  late bool pushEnabled;

  @MapTo('morning_time')
  String? morningTime;

  @MapTo('evening_time')
  String? eveningTime;

  @MapTo('contextual_allowed')
  late bool contextualAllowed;
}

/// Notification delivery log.
@RealmModel()
class _NotificationEntity {
  @PrimaryKey()
  @MapTo('notification_id')
  late String notificationId;

  @MapTo('user_id')
  late String userId;

  late String type; // review_due, daily_quest, streak, ...

  String? payload; // JSON string

  @MapTo('sent_at')
  DateTime? sentAt;

  @MapTo('read_at')
  DateTime? readAt;
}

/// Administrative audit trail.
@RealmModel()
class _AdminActionEntity {
  @PrimaryKey()
  @MapTo('action_id')
  late String actionId;

  @MapTo('admin_id')
  late String adminId;

  @MapTo('target_type')
  late String targetType; // post | user | comment

  @MapTo('target_id')
  late String targetId;

  late String action; // hide | ban | unban | warn

  String? reason;

  @MapTo('created_at')
  late DateTime createdAt;
}
