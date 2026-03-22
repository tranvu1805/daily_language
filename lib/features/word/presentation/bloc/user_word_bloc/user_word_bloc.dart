import 'dart:async';

import 'package:daily_language/features/word/domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_word_event.dart';
part 'user_word_state.dart';

class UserWordBloc extends Bloc<UserWordEvent, UserWordState> {
  final GetUserWordUseCase _getUserWordUseCase;
  final CreateUserWordUseCase _createUserWordUseCase;
  final UpdateUserWordUseCase _updateUserWordUseCase;
  final DeleteUserWordUseCase _deleteUserWordUseCase;

  UserWordBloc({
    required GetUserWordUseCase getUserWordUseCase,
    required CreateUserWordUseCase createUserWordUseCase,
    required UpdateUserWordUseCase updateUserWordUseCase,
    required DeleteUserWordUseCase deleteUserWordUseCase,
  }) : _getUserWordUseCase = getUserWordUseCase,
       _createUserWordUseCase = createUserWordUseCase,
       _updateUserWordUseCase = updateUserWordUseCase,
       _deleteUserWordUseCase = deleteUserWordUseCase,
       super(UserWordInitial()) {
    on<UserWordRequested>(_onWordRequested);
    on<UserWordCreated>(_onCreated);
    on<UserWordUpdated>(_onUpdated);
    on<UserWordDeleted>(_onDeleted);
  }

  Future<void> _onWordRequested(
    UserWordRequested event,
    Emitter<UserWordState> emit,
  ) async {
    emit(UserWordInProgress());
    final result = await _getUserWordUseCase(event.param);
    result.fold(
      (failure) => emit(UserWordFailure(error: failure.message)),
      (userWord) => emit(UserWordSuccess(userWord: userWord)),
    );
  }

  Future<void> _onCreated(
    UserWordCreated event,
    Emitter<UserWordState> emit,
  ) async {
    emit(UserWordInProgress());
    final result = await _createUserWordUseCase(event.param);
    result.fold((failure) => emit(UserWordFailure(error: failure.message)), (_) {
      emit(UserWordCreateSuccess());
    });
  }

  Future<void> _onUpdated(
    UserWordUpdated event,
    Emitter<UserWordState> emit,
  ) async {
    emit(UserWordInProgress());
    final result = await _updateUserWordUseCase(event.param);
    result.fold((failure) => emit(UserWordFailure(error: failure.message)), (_) {
      emit(UserWordUpdateSuccess());
    });
  }

  Future<void> _onDeleted(
    UserWordDeleted event,
    Emitter<UserWordState> emit,
  ) async {
    emit(UserWordInProgress());
    final result = await _deleteUserWordUseCase(event.param);
    result.fold((failure) => emit(UserWordFailure(error: failure.message)), (_) {
      emit(UserWordDeleteSuccess());
    });
  }
}
