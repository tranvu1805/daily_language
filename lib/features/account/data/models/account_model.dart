import 'package:daily_language/features/account/domain/domain.dart';
import 'package:equatable/equatable.dart';

class AccountModel extends Equatable {
  final String? uid;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final int? streak;

  const AccountModel({this.uid, this.fullName, this.email, this.phoneNumber, this.streak});

  const AccountModel.empty({
    this.uid = '',
    this.fullName = '',
    this.email = '',
    this.phoneNumber = '',
    this.streak = -1,
  });

  const AccountModel.toCreate({
    required this.uid,
    required this.email,
    required this.fullName,
    this.phoneNumber = '',
    this.streak = 0,
  });

  Account toEntity() => Account(
    uid: uid ?? '',
    fullName: fullName ?? '',
    email: email ?? '',
    phoneNumber: phoneNumber ?? '',
    streak: streak ?? -1,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uid'] = uid;
    map['fullName'] = fullName;
    map['email'] = email;
    map['phoneNumber'] = phoneNumber;
    map['streak'] = streak;
    return map;
  }

  AccountModel.fromJson(dynamic json)
    : this(
        uid: json['uid'] as String?,
        fullName: json['fullName'] as String?,
        email: json['email'] as String?,
        phoneNumber: json['phoneNumber'] as String?,
        streak: json['streak'] as int?,
      );

  @override
  List<Object?> get props => [uid, fullName, email, phoneNumber, streak];
}
