import 'package:daily_language/features/authentication/domain/domain.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String? id;
  final String? username;
  final String? email;
  final String? avatarUrl;

  const UserModel({this.id, this.username, this.email, this.avatarUrl});

  const UserModel.empty({this.id = '', this.username = '', this.email = '', this.avatarUrl = ''});

  const UserModel.toUpdate({
    required this.id,
    required this.username,
    required this.email,
    required this.avatarUrl,
  });

  User toEntity() =>
      User(id: id ?? '', username: username ?? '', email: email ?? '', avatarUrl: avatarUrl ?? '');

  // Map<String, dynamic> toJson() {
  //   final map = <String, dynamic>{};
  //   return map;
  // }
  //
  // UserModel.fromJson(dynamic json) : this();

  @override
  List<Object?> get props => [id, username, email, avatarUrl];
}
