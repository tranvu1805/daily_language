import 'dart:async';

import 'package:daily_language/core/constants/app.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_words_event.dart';
part 'user_words_state.dart';

class UserWordsBloc extends Bloc<UserWordsEvent, UserWordsState> {
  final GetUserWordsUseCase _getUserWordsUseCase;

  UserWordsBloc({required GetUserWordsUseCase getUserWordsUseCase})
    : _getUserWordsUseCase = getUserWordsUseCase,
      super(const UserWordsState()) {
    on<UserWordsRequested>(_onRequested);
    on<UserWordsRefreshed>(_onRefreshed);
  }

  Future<void> _onRequested(
    UserWordsRequested event,
    Emitter<UserWordsState> emit,
  ) async {
    if (state.hasReachedMax || state.status == UserWordsStatus.loading) return;
    if (state.status == UserWordsStatus.initial) {
      emit(
        state.copyWith(
          status: UserWordsStatus.loading,
          action: UserWordsAction.request,
        ),
      );
    }
    final result = await _getUserWordsUseCase(event.param);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: UserWordsStatus.failure,
          error: failure.message,
          action: UserWordsAction.request,
        ),
      ),
      (userWords) => emit(
        state.copyWith(
          status: UserWordsStatus.success,
          userWords: [...state.userWords, ...userWords],
          lastDocId: userWords.isNotEmpty ? userWords.last.id : state.lastDocId,
          hasReachedMax: userWords.length < pageSize,
          action: UserWordsAction.request,
        ),
      ),
    );
  }

  Future<void> _onRefreshed(
    UserWordsRefreshed event,
    Emitter<UserWordsState> emit,
  ) async {
    emit(const UserWordsState());
    add(UserWordsRequested(param: event.param));
  }
}
