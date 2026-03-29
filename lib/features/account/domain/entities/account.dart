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
    this.lastActivityAt,
    this.lastAiReviewAt,
    this.aiReviewCount = 0,
    this.aiReviewCoins = 0,
    required this.avatarUrl,
    this.isPremium = false,
  });

  const Account.empty({
    this.uid = '',
    this.fullName = '',
    this.email = '',
    this.phoneNumber = '',
    this.streak = 0,
    this.maxStreak = 0,
    this.lastActivityAt,
    this.lastAiReviewAt,
    this.aiReviewCount = 0,
    this.aiReviewCoins = 0,
    this.avatarUrl = '',
    this.isPremium = false,
  });

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
