part of 'grammar_bloc.dart';

abstract class GrammarEvent extends Equatable {
  const GrammarEvent();

  @override
  List<Object> get props => [];
}

class CorrectGrammarRequested extends GrammarEvent {
  final GetGrammarCorrectionParams param;

  const CorrectGrammarRequested(this.param);

  @override
  List<Object> get props => [param];
}
