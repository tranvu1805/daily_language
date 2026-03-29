part of 'grammar_bloc.dart';

abstract class GrammarEvent extends Equatable {
  const GrammarEvent();

  @override
  List<Object> get props => [];
}

class CorrectGrammarRequested extends GrammarEvent {
  final String text;

  const CorrectGrammarRequested(this.text);

  @override
  List<Object> get props => [text];
}
