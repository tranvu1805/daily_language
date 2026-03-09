part of 'records_bloc.dart';

sealed class RecordsEvent extends Equatable {
  const RecordsEvent();

  @override
  List<Object> get props => [];
}

final class RecordsRequested extends RecordsEvent {
  final GetRecordsUseCaseParams param;

  const RecordsRequested({required this.param});

  @override
  List<Object> get props => [param];
}

final class RecordsRefreshed extends RecordsEvent {
  final GetRecordsUseCaseParams param;

  const RecordsRefreshed({required this.param});

  @override
  List<Object> get props => [param];
}
