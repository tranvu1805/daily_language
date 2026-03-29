part of 'locale_bloc.dart';

abstract class LocaleEvent extends Equatable {
  const LocaleEvent();

  @override
  List<Object?> get props => [];
}

class LocaleChanged extends LocaleEvent {
  final String localeCode;

  const LocaleChanged(this.localeCode);

  @override
  List<Object?> get props => [localeCode];
}
