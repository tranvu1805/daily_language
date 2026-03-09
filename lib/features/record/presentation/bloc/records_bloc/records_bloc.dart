import 'dart:async';

import 'package:daily_language/core/constants/app.dart';
import 'package:daily_language/features/record/domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'records_event.dart';
part 'records_state.dart';

class RecordsBloc extends Bloc<RecordsEvent, RecordsState> {
  final GetRecordsUseCase _getRecordsUseCase;

  RecordsBloc({required GetRecordsUseCase getRecordsUseCase})
    : _getRecordsUseCase = getRecordsUseCase,
      super(const RecordsState()) {
    on<RecordsRequested>(_onRequested);
    on<RecordsRefreshed>(_onRefreshed);
  }

  Future<void> _onRequested(
    RecordsRequested event,
    Emitter<RecordsState> emit,
  ) async {
    if (state.hasReachedMax || state.status == RecordsStatus.loading) return;
    if (state.status == RecordsStatus.initial) {
      emit(
        state.copyWith(
          status: RecordsStatus.loading,
          action: RecordsAction.request,
        ),
      );
    }
    final result = await _getRecordsUseCase(event.param);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RecordsStatus.failure,
          error: failure.message,
          action: RecordsAction.request,
        ),
      ),
      (records) => emit(
        state.copyWith(
          status: RecordsStatus.success,
          records: [...state.records, ...records],
          lastDocId: records.isNotEmpty ? records.last.id : state.lastDocId,
          hasReachedMax: records.length < pageSize,
          action: RecordsAction.request,
        ),
      ),
    );
  }

  Future<void> _onRefreshed(
    RecordsRefreshed event,
    Emitter<RecordsState> emit,
  ) async {
    emit(const RecordsState());
    add(RecordsRequested(param: event.param));
  }
}
