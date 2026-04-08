part of 'authentication_bloc.dart';

sealed class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

final class AuthenticationInitial extends AuthenticationState {}

final class AuthenticationInProgress extends AuthenticationState {}

final class AuthenticationUpdateSuccess extends AuthenticationState {}

final class AuthenticationSuccess extends AuthenticationState {
  final User user;

  const AuthenticationSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

final class AuthenticationFailure extends AuthenticationState {
  final String error;
  final bool isSilent;

  const AuthenticationFailure({required this.error, this.isSilent = false});

  @override
  List<Object> get props => [error, isSilent];
}
