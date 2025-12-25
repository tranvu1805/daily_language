import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String email;
  final String avatarUrl;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.avatarUrl,
  });

  const User.empty({this.id = '', this.username = '', this.email = '', this.avatarUrl = ''});

  @override
  List<Object> get props => [id, username, email, avatarUrl];
}
