part of 'locale_bloc.dart';

abstract class LocaleState extends Equatable {
  const LocaleState();

  @override
  List<Object?> get props => [];
}

class LocaleInitial extends LocaleState {
  final String localeCode;

  const LocaleInitial(this.localeCode);

  @override
  List<Object?> get props => [localeCode];
}

class LocaleLoaded extends LocaleState {
  final String localeCode;

  const LocaleLoaded(this.localeCode);

  @override
  List<Object?> get props => [localeCode];
}
