import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final String uid;
  final String fullName;
  final String email;
  final String phoneNumber;
  final int streak;

  const Account({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.streak,
  });

  const Account.empty({
    this.uid = '',
    this.fullName = '',
    this.email = '',
    this.phoneNumber = '',
    this.streak = -1,
  });

  @override
  List<Object> get props => [uid, fullName, email, phoneNumber, streak];
}
