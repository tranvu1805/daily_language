import 'package:daily_language/core/utils/helper/local_storage_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'locale_event.dart';
part 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  final LocalStorageHelper _storage;

  LocaleBloc(this._storage) : super(LocaleInitial(_storage.appLocale)) {
    on<LocaleChanged>(_onLocaleChanged);
  }

  void _onLocaleChanged(LocaleChanged event, Emitter<LocaleState> emit) async {
    await _storage.setAppLocale(event.localeCode);
    emit(LocaleLoaded(event.localeCode));
  }
}
