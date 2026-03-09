part of 'records_bloc.dart';

enum RecordsStatus { initial, loading, success, failure }

enum RecordsAction { none, request, refresh }

final class RecordsState extends Equatable {
  const RecordsState({
    this.records = const [],
    this.status = RecordsStatus.initial,
    this.hasReachedMax = false,
    this.lastDocId,
    this.action = RecordsAction.none,
    this.error = '',
  });

  final List<Record> records;
  final RecordsAction action;
  final String error;
  final bool hasReachedMax;
  final String? lastDocId;
  final RecordsStatus status;

  RecordsState copyWith({
    List<Record>? records,
    RecordsStatus? status,
    bool? hasReachedMax,
    String? lastDocId,
    RecordsAction? action,
    String? error,
  }) {
    return RecordsState(
      records: records ?? this.records,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      lastDocId: lastDocId ?? this.lastDocId,
      action: action ?? this.action,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    records,
    status,
    hasReachedMax,
    lastDocId,
    action,
    error,
  ];
}
