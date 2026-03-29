part of 'grammar_bloc.dart';

abstract class GrammarState extends Equatable {
  const GrammarState();

  @override
  List<Object> get props => [];
}

class GrammarInitial extends GrammarState {}

class GrammarInProgress extends GrammarState {}

class GrammarSuccess extends GrammarState {
  final GrammarCorrection correction;

  const GrammarSuccess(this.correction);

  @override
  List<Object> get props => [correction];
}

class GrammarFailure extends GrammarState {
  final String error;

  const GrammarFailure(this.error);

  @override
  List<Object> get props => [error];
}
