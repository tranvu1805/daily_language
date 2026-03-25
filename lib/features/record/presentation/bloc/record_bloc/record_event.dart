part of 'record_bloc.dart';

sealed class RecordEvent extends Equatable {
  const RecordEvent();
  @override
  List<Object> get props => [];
}

final class RecordRequested extends RecordEvent {
  final GetRecordUseCaseParams param;

  const RecordRequested({required this.param});

  @override
  List<Object> get props => [param];
}

final class RecordCreated extends RecordEvent {
  final CreateRecordUseCaseParams param;

  const RecordCreated({required this.param});

  @override
  List<Object> get props => [param];
}

final class RecordUpdated extends RecordEvent {
  final UpdateRecordUseCaseParams param;

  const RecordUpdated({required this.param});

  @override
  List<Object> get props => [param];
}

final class RecordDeleted extends RecordEvent {
  final String id;

  const RecordDeleted({required this.id});

  @override
  List<Object> get props => [id];
}

final class RecordVietnameseTranslatedRequested extends RecordEvent {
  final TranslateVietnameseToEnglishUseCaseParams param;

  const RecordVietnameseTranslatedRequested({
    required this.param,
  });

  @override
  List<Object> get props => [param];
}
