import 'dart:async';

import 'package:daily_language/core/constants/app.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_words_event.dart';
part 'user_words_state.dart';

class UserWordsBloc extends Bloc<UserWordsEvent, UserWordsState> {
  final GetUserWordsUseCase _getUserWordsUseCase;
  final GetDictionaryWordByIdUseCase _getDictionaryWordByIdUseCase;

  UserWordsBloc({
    required GetUserWordsUseCase getUserWordsUseCase,
    required GetDictionaryWordByIdUseCase getDictionaryWordByIdUseCase,
  }) : _getUserWordsUseCase = getUserWordsUseCase,
       _getDictionaryWordByIdUseCase = getDictionaryWordByIdUseCase,
       super(const UserWordsState()) {
    on<UserWordsRequested>(_onRequested);
    on<UserWordsRefreshed>(_onRefreshed);
    on<UserWordDetailRequested>(_onDetailRequested);
  }

  Future<void> _onDetailRequested(
    UserWordDetailRequested event,
    Emitter<UserWordsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: UserWordsStatus.loading,
        action: UserWordsAction.detail,
        selectedWordDetail: null,
      ),
    );
    final result = await _getDictionaryWordByIdUseCase(event.params);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: UserWordsStatus.failure,
          action: UserWordsAction.detail,
          error: failure.message,
        ),
      ),
      (word) => emit(
        state.copyWith(
          status: UserWordsStatus.success,
          action: UserWordsAction.detail,
          selectedWordDetail: word,
        ),
      ),
    );
  }

  Future<void> _onRequested(
    UserWordsRequested event,
    Emitter<UserWordsState> emit,
  ) async {
    if (state.hasReachedMax ||
        (state.status == UserWordsStatus.loading &&
            state.action == UserWordsAction.request)) {
      return;
    }

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
