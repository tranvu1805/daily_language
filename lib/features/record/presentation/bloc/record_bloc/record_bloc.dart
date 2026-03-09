import 'dart:async';

import 'package:daily_language/features/record/domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'record_event.dart';
part 'record_state.dart';

class RecordBloc extends Bloc<RecordEvent, RecordState> {
  final GetRecordUseCase _getRecordUseCase;
  final CreateRecordUseCase _createRecordUseCase;
  final UpdateRecordUseCase _updateRecordUseCase;
  final DeleteRecordUseCase _deleteRecordUseCase;

  RecordBloc({
    required GetRecordUseCase getRecordUseCase,
    required CreateRecordUseCase createRecordUseCase,
    required UpdateRecordUseCase updateRecordUseCase,
    required DeleteRecordUseCase deleteRecordUseCase,
  }) : _getRecordUseCase = getRecordUseCase,
       _createRecordUseCase = createRecordUseCase,
       _updateRecordUseCase = updateRecordUseCase,
       _deleteRecordUseCase = deleteRecordUseCase,
       super(RecordInitial()) {
    on<RecordRequested>(_onRecordRequested);
    on<RecordCreated>(_onCreated);
    on<RecordUpdated>(_onUpdated);
    on<RecordDeleted>(_onDeleted);
  }

  Future<void> _onRecordRequested(
    RecordRequested event,
    Emitter<RecordState> emit,
  ) async {
    emit(RecordInProgress());
    final result = await _getRecordUseCase(event.param);
    result.fold(
      (failure) => emit(RecordFailure(error: failure.message)),
      (record) => emit(RecordSuccess(record: record)),
    );
  }

  Future<void> _onCreated(
    RecordCreated event,
    Emitter<RecordState> emit,
  ) async {
    emit(RecordInProgress());
    final result = await _createRecordUseCase(event.param);
    result.fold((failure) => emit(RecordFailure(error: failure.message)), (_) {
      emit(RecordCreateSuccess());
    });
  }

  Future<void> _onUpdated(
    RecordUpdated event,
    Emitter<RecordState> emit,
  ) async {
    emit(RecordInProgress());
    final result = await _updateRecordUseCase(event.param);
    result.fold((failure) => emit(RecordFailure(error: failure.message)), (_) {
      emit(RecordUpdateSuccess());
    });
  }

  Future<void> _onDeleted(
    RecordDeleted event,
    Emitter<RecordState> emit,
  ) async {
    emit(RecordInProgress());
    final result = await _deleteRecordUseCase(event.id);
    result.fold((failure) => emit(RecordFailure(error: failure.message)), (_) {
      emit(RecordDeleteSuccess());
    });
  }
}
