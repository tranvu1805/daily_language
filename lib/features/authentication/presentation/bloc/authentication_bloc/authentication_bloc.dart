import 'dart:async';

import 'package:daily_language/features/authentication/domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final GetUserUseCase _getUserUseCase;
  final LoginWithGoogleUseCase _loginWithGoogleUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthenticationBloc({
    required GetUserUseCase getUserUseCase,
    required LogoutUseCase logoutUseCase,
    required LoginWithGoogleUseCase loginWithGoogleUseCase,
  }) : _getUserUseCase = getUserUseCase,
       _logoutUseCase = logoutUseCase,
       _loginWithGoogleUseCase = loginWithGoogleUseCase,
       super(AuthenticationInitial()) {
    on<AuthenticationGoogleLoggedIn>(_onLoginWithGoogleRequested);
    on<AuthenticationRequested>(_onAuthenticationRequested);
    on<AuthenticationLoggedOut>(_onAuthenticationLoggedOut);
  }

  Future<void> _onLoginWithGoogleRequested(
    AuthenticationGoogleLoggedIn event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationInProgress());
    final result = await _loginWithGoogleUseCase();
    result.fold(
      (failure) => emit(AuthenticationFailure(error: failure.message)),
      (_) => add(AuthenticationRequested()),
    );
  }

  Future<void> _onAuthenticationRequested(
    AuthenticationRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationInProgress());
    await emit.forEach<User?>(
      _getUserUseCase(),
      onData: (user) => user != null
          ? AuthenticationSuccess(user: user)
          : const AuthenticationFailure(error: 'Unauthenticated'),
      onError: (e, _) => AuthenticationFailure(error: e.toString()),
    );
  }

  Future<void> _onAuthenticationLoggedOut(
    AuthenticationLoggedOut event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationInProgress());
    final result = await _logoutUseCase();
    result.fold(
      (failure) => emit(AuthenticationFailure(error: failure.message)),
      (_) => emit(const AuthenticationFailure(error: 'Unauthenticated')),
    );
  }
}
