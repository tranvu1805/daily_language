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

  const Account({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.streak,
    required this.maxStreak,
    this.lastActivityAt,
    required this.avatarUrl,
  });

  const Account.empty({
    this.uid = '',
    this.fullName = '',
    this.email = '',
    this.phoneNumber = '',
    this.streak = 0,
    this.maxStreak = 0,
    this.lastActivityAt,
    this.avatarUrl = '',
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
    avatarUrl,
  ];
}
