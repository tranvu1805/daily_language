import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final String uid;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String avatarUrl;
  final int streak;
  final int maxStreak;
  final DateTime? lastActivityAt;
  final DateTime? lastAiReviewAt;
  final int aiReviewCount;
  final int aiReviewCoins;
  final bool isPremium;

  const Account({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.streak,
    required this.maxStreak,
    required this.lastActivityAt,
    this.lastAiReviewAt,
    this.aiReviewCount = 0,
    this.aiReviewCoins = 0,
    required this.avatarUrl,
    this.isPremium = false,
  });

  Account copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? phoneNumber,
    int? streak,
    int? maxStreak,
    DateTime? lastActivityAt,
    DateTime? lastAiReviewAt,
    int? aiReviewCount,
    int? aiReviewCoins,
    String? avatarUrl,
    bool? isPremium,
  }) {
    return Account(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      streak: streak ?? this.streak,
      maxStreak: maxStreak ?? this.maxStreak,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      lastAiReviewAt: lastAiReviewAt ?? this.lastAiReviewAt,
      aiReviewCount: aiReviewCount ?? this.aiReviewCount,
      aiReviewCoins: aiReviewCoins ?? this.aiReviewCoins,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  Account.empty({
    this.uid = '',
    this.fullName = '',
    this.email = '',
    this.phoneNumber = '',
    this.streak = 0,
    this.maxStreak = 0,
    DateTime? lastActivityAt,
    this.lastAiReviewAt,
    this.aiReviewCount = 0,
    this.aiReviewCoins = 0,
    this.avatarUrl = '',
    this.isPremium = false,
  }) : lastActivityAt = lastActivityAt ?? DateTime.now();

  @override
  List<Object?> get props => [
    uid,
    fullName,
    email,
    phoneNumber,
    streak,
    maxStreak,
    lastActivityAt,
    lastAiReviewAt,
    aiReviewCount,
    aiReviewCoins,
    avatarUrl,
    isPremium,
  ];
}
