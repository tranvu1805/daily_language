import 'dart:async';

import 'package:daily_language/features/word/domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'word_event.dart';
part 'word_state.dart';

class WordBloc extends Bloc<WordEvent, WordState> {
  final GetWordUseCase _getWordUseCase;
  final CreateWordUseCase _createWordUseCase;
  final UpdateWordUseCase _updateWordUseCase;
  final DeleteWordUseCase _deleteWordUseCase;

  WordBloc({
    required GetWordUseCase getWordUseCase,
    required CreateWordUseCase createWordUseCase,
    required UpdateWordUseCase updateWordUseCase,
    required DeleteWordUseCase deleteWordUseCase,
  }) : _getWordUseCase = getWordUseCase,
       _createWordUseCase = createWordUseCase,
       _updateWordUseCase = updateWordUseCase,
       _deleteWordUseCase = deleteWordUseCase,
       super(WordInitial()) {
    on<WordRequested>(_onWordRequested);
    on<WordCreated>(_onCreated);
    on<WordUpdated>(_onUpdated);
    on<WordDeleted>(_onDeleted);
  }

  Future<void> _onWordRequested(
    WordRequested event,
    Emitter<WordState> emit,
  ) async {
    emit(WordInProgress());
    final result = await _getWordUseCase(event.param);
    result.fold(
      (failure) => emit(WordFailure(error: failure.message)),
      (word) => emit(WordSuccess(word: word)),
    );
  }

  Future<void> _onCreated(
    WordCreated event,
    Emitter<WordState> emit,
  ) async {
    emit(WordInProgress());
    final result = await _createWordUseCase(event.param);
    result.fold((failure) => emit(WordFailure(error: failure.message)), (_) {
      emit(WordCreateSuccess());
    });
  }

  Future<void> _onUpdated(
    WordUpdated event,
    Emitter<WordState> emit,
  ) async {
    emit(WordInProgress());
    final result = await _updateWordUseCase(event.param);
    result.fold((failure) => emit(WordFailure(error: failure.message)), (_) {
      emit(WordUpdateSuccess());
    });
  }

  Future<void> _onDeleted(
    WordDeleted event,
    Emitter<WordState> emit,
  ) async {
    emit(WordInProgress());
    final result = await _deleteWordUseCase(event.id);
    result.fold((failure) => emit(WordFailure(error: failure.message)), (_) {
      emit(WordDeleteSuccess());
    });
  }
}
