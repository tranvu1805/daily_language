import 'package:daily_language/features/account/domain/domain.dart';
import 'package:equatable/equatable.dart';

class AccountModel extends Equatable {
  final String? uid;
  final String? fullName;
  final String? avatarUrl;
  final String? email;
  final String? phoneNumber;
  final int? streak;
  final int? maxStreak;
  final DateTime? lastActivityAt;
  final int? aiReviewCount;
  final int? aiReviewCoins;
  final DateTime? lastAiReviewAt;
  final bool? isPremium;

  const AccountModel({
    this.uid,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.streak,
    this.maxStreak,
    this.lastActivityAt,
    this.aiReviewCount,
    this.aiReviewCoins,
    this.lastAiReviewAt,
    this.avatarUrl,
    this.isPremium,
  });

  const AccountModel.empty({
    this.uid = '',
    this.fullName = '',
    this.email = '',
    this.phoneNumber = '',
    this.streak = 0,
    this.maxStreak = 0,
    this.lastActivityAt,
    this.aiReviewCount = 0,
    this.aiReviewCoins = 0,
    this.lastAiReviewAt,
    this.avatarUrl = '',
    this.isPremium = false,
  });

  const AccountModel.toCreate({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.avatarUrl,
    this.phoneNumber = '',
    this.streak = 0,
    this.maxStreak = 0,
    this.lastActivityAt,
    this.aiReviewCount = 0,
    this.aiReviewCoins = 0,
    this.lastAiReviewAt,
    this.isPremium = false,
  });

  Account toEntity() => Account(
    uid: uid ?? '',
    fullName: fullName ?? '',
    email: email ?? '',
    phoneNumber: phoneNumber ?? '',
    streak: streak ?? 0,
    maxStreak: maxStreak ?? 0,
    lastActivityAt: lastActivityAt,
    aiReviewCount: aiReviewCount ?? 0,
    aiReviewCoins: aiReviewCoins ?? 0,
    lastAiReviewAt: lastAiReviewAt,
    avatarUrl: avatarUrl ?? '',
    isPremium: isPremium ?? false,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uid'] = uid;
    map['fullName'] = fullName;
    map['email'] = email;
    map['avatarUrl'] = avatarUrl;
    map['phoneNumber'] = phoneNumber;
    map['streak'] = streak;
    map['maxStreak'] = maxStreak;
    map['lastActivityAt'] = lastActivityAt;
    map['aiReviewCount'] = aiReviewCount;
    map['aiReviewCoins'] = aiReviewCoins;
    map['lastAiReviewAt'] = lastAiReviewAt;
    map['isPremium'] = isPremium;
    return map;
  }

  Map<String, dynamic> toCreateJson() {
    final map = <String, dynamic>{};
    map['uid'] = uid;
    map['fullName'] = fullName;
    map['email'] = email;
    map['avatarUrl'] = avatarUrl;
    map['phoneNumber'] = phoneNumber;
    map['streak'] = 0;
    map['maxStreak'] = 0;
    map['lastActivityAt'] = DateTime.now();
    map['aiReviewCount'] = 0;
    map['aiReviewCoins'] = 0;
    map['lastAiReviewAt'] = null;
    map['isPremium'] = false;
    return map;
  }

  Map<String, dynamic> toUpdateJson() {
    final map = <String, dynamic>{};
    map['fullName'] = fullName;
    map['phoneNumber'] = phoneNumber;
    if (streak != null) map['streak'] = streak;
    if (maxStreak != null) map['maxStreak'] = maxStreak;
    if (lastActivityAt != null) map['lastActivityAt'] = lastActivityAt;
    if (aiReviewCount != null) map['aiReviewCount'] = aiReviewCount;
    if (aiReviewCoins != null) map['aiReviewCoins'] = aiReviewCoins;
    if (lastAiReviewAt != null) map['lastAiReviewAt'] = lastAiReviewAt;
    if (isPremium != null) map['isPremium'] = isPremium;
    return map;
  }

  factory AccountModel.fromUpdateParams(UpdateAccountUseCaseParams p) {
    return AccountModel(
      uid: p.uid,
      fullName: p.fullName,
      phoneNumber: p.phoneNumber,
      streak: p.streak,
      maxStreak: p.maxStreak,
      lastActivityAt: p.lastActivityAt,
      aiReviewCount: p.aiReviewCount,
      aiReviewCoins: p.aiReviewCoins,
      lastAiReviewAt: p.lastAiReviewAt,
      isPremium: p.isPremium,
    );
  }

  AccountModel.fromJson(dynamic json)
    : this(
        uid: json['uid'] as String?,
        fullName: json['fullName'] as String?,
        email: json['email'] as String?,
        phoneNumber: json['phoneNumber'] as String?,
        streak: json['streak'] as int?,
        maxStreak: json['maxStreak'] as int?,
        lastActivityAt: json['lastActivityAt'] != null
            ? (json['lastActivityAt'] as dynamic).toDate() as DateTime?
            : null,
        lastAiReviewAt: json['lastAiReviewAt'] != null
            ? (json['lastAiReviewAt'] as dynamic).toDate() as DateTime?
            : null,
        aiReviewCount: json['aiReviewCount'] as int?,
        aiReviewCoins: json['aiReviewCoins'] as int?,
        avatarUrl: json['avatarUrl'] as String?,
        isPremium: json['isPremium'] as bool?,
      );

  @override
  List<Object?> get props => [
    uid,
    fullName,
    email,
    phoneNumber,
    streak,
    maxStreak,
    lastActivityAt,
    aiReviewCount,
    aiReviewCoins,
    lastAiReviewAt,
    avatarUrl,
    isPremium,
  ];
}
