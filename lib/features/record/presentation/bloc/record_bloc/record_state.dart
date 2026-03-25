part of 'record_bloc.dart';

sealed class RecordState extends Equatable {
  const RecordState();

  @override
  List<Object> get props => [];
}

final class RecordInitial extends RecordState {}

final class RecordInProgress extends RecordState {}

final class RecordCreateSuccess extends RecordState {}

final class RecordUpdateSuccess extends RecordState {}

final class RecordDeleteSuccess extends RecordState {}

final class RecordTranslateInProgress extends RecordState {}

final class RecordTranslateSuccess extends RecordState {
  final String translatedContent;

  const RecordTranslateSuccess({required this.translatedContent});

  @override
  List<Object> get props => [translatedContent];
}

final class RecordSuccess extends RecordState {
  final Record record;

  const RecordSuccess({required this.record});

  @override
  List<Object> get props => [record];
}

final class RecordFailure extends RecordState {
  final String error;

  const RecordFailure({required this.error});

  @override
  List<Object> get props => [error];
}
