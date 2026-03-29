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

  const AccountModel({
    this.uid,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.streak,
    this.maxStreak,
    this.lastActivityAt,
    this.avatarUrl,
  });

  const AccountModel.empty({
    this.uid = '',
    this.fullName = '',
    this.email = '',
    this.phoneNumber = '',
    this.streak = 0,
    this.maxStreak = 0,
    this.lastActivityAt,
    this.avatarUrl = '',
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
  });

  Account toEntity() => Account(
    uid: uid ?? '',
    fullName: fullName ?? '',
    email: email ?? '',
    phoneNumber: phoneNumber ?? '',
    streak: streak ?? 0,
    maxStreak: maxStreak ?? 0,
    lastActivityAt: lastActivityAt,
    avatarUrl: avatarUrl ?? '',
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
    return map;
  }

  Map<String, dynamic> toUpdateJson() {
    final map = <String, dynamic>{};
    map['fullName'] = fullName;
    map['phoneNumber'] = phoneNumber;
    if (streak != null) map['streak'] = streak;
    if (maxStreak != null) map['maxStreak'] = maxStreak;
    if (lastActivityAt != null) map['lastActivityAt'] = lastActivityAt;
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
        avatarUrl: json['avatarUrl'] as String?,
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
    avatarUrl,
  ];
}
