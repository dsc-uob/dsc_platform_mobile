part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class FetchSettings extends SettingsEvent {}

class ChangeLanguage extends SettingsEvent {
  final String langCode;

  const ChangeLanguage(this.langCode);

  @override
  List<Object> get props => [langCode];
}

class ChangeFont extends SettingsEvent {
  final String fontFamily;

  const ChangeFont(this.fontFamily);

  @override
  List<Object> get props => [fontFamily];
}
