import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/domain.dart';

part 'grammar_event.dart';
part 'grammar_state.dart';

class GrammarBloc extends Bloc<GrammarEvent, GrammarState> {
  final CorrectGrammarUseCase _correctGrammarUseCase;

  GrammarBloc({required CorrectGrammarUseCase correctGrammarUseCase})
    : _correctGrammarUseCase = correctGrammarUseCase,
      super(GrammarInitial()) {
    on<CorrectGrammarRequested>(_onCorrectGrammarRequested);
  }

  Future<void> _onCorrectGrammarRequested(
    CorrectGrammarRequested event,
    Emitter<GrammarState> emit,
  ) async {
    emit(GrammarInProgress());
    final result = await _correctGrammarUseCase(event.text);
    result.fold(
      (failure) => emit(GrammarFailure(failure.message)),
      (correction) => emit(GrammarSuccess(correction)),
    );
  }
}
