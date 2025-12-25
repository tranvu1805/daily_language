part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

final class AuthenticationRequested extends AuthenticationEvent {}

final class AuthenticationGoogleLoggedIn extends AuthenticationEvent {}

final class AuthenticationLoggedOut extends AuthenticationEvent {}
