import 'dart:async';

import 'package:daily_language/features/word/domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'words_event.dart';
part 'words_state.dart';

class WordsBloc extends Bloc<WordsEvent, WordsState> {
  final GetDictionaryWordsUseCase _getDictionaryWordsUseCase;

  WordsBloc({required GetDictionaryWordsUseCase getDictionaryWordsUseCase})
    : _getDictionaryWordsUseCase = getDictionaryWordsUseCase,
      super(const WordsState()) {
    on<WordsRequested>(_onWordRequested);
    on<WordsLoadMore>(_onWordsLoadMore);
  }

  Future<void> _onWordRequested(
    WordsRequested event,
    Emitter<WordsState> emit,
  ) async {
    emit(state.copyWith(status: WordStatus.loading, words: [], hasReachedMax: false));

    final result = await _getDictionaryWordsUseCase(event.param);
    result.fold(
      (failure) => emit(
        state.copyWith(error: failure.message, status: WordStatus.failure),
      ),
      (words) {
        emit(state.copyWith(
          words: words,
          status: WordStatus.success,
          hasReachedMax: words.length < event.param.limit,
        ));
      },
    );
  }

  Future<void> _onWordsLoadMore(
    WordsLoadMore event,
    Emitter<WordsState> emit,
  ) async {
    if (state.hasReachedMax) return;

    emit(state.copyWith(status: WordStatus.loading));

    final result = await _getDictionaryWordsUseCase(event.param);
    result.fold(
      (failure) => emit(
        state.copyWith(error: failure.message, status: WordStatus.failure),
      ),
      (words) {
        final List<Word> updatedWords = List.of(state.words)..addAll(words);

        emit(state.copyWith(
          words: updatedWords,
          status: WordStatus.success,
          hasReachedMax: words.length < event.param.limit,
        ));
      },
    );
  }
}
