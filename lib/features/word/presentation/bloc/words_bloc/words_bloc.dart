import 'dart:async';

import 'package:daily_language/core/constants/app.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'words_event.dart';
part 'words_state.dart';

class WordsBloc extends Bloc<WordsEvent, WordsState> {
  final GetWordsUseCase _getWordsUseCase;

  WordsBloc({required GetWordsUseCase getWordsUseCase})
    : _getWordsUseCase = getWordsUseCase,
      super(const WordsState()) {
    on<WordsRequested>(_onRequested);
    on<WordsRefreshed>(_onRefreshed);
  }

  Future<void> _onRequested(
    WordsRequested event,
    Emitter<WordsState> emit,
  ) async {
    if (state.hasReachedMax || state.status == WordsStatus.loading) return;
    if (state.status == WordsStatus.initial) {
      emit(
        state.copyWith(
          status: WordsStatus.loading,
          action: WordsAction.request,
        ),
      );
    }
    final result = await _getWordsUseCase(event.param);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: WordsStatus.failure,
          error: failure.message,
          action: WordsAction.request,
        ),
      ),
      (words) => emit(
        state.copyWith(
          status: WordsStatus.success,
          words: [...state.words, ...words],
          lastDocId: words.isNotEmpty ? words.last.id : state.lastDocId,
          hasReachedMax: words.length < pageSize,
          action: WordsAction.request,
        ),
      ),
    );
  }

  Future<void> _onRefreshed(
    WordsRefreshed event,
    Emitter<WordsState> emit,
  ) async {
    emit(const WordsState());
    add(WordsRequested(param: event.param));
  }
}
