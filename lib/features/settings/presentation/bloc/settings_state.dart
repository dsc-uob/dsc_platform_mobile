part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final Settings settings;

  const SettingsState(this.settings);

  factory SettingsState.defaultSettings() {
    return SettingsState(
      Settings(
        langCode: 'ar',
        fontFamily: 'Almarai',
      ),
    );
  }

  @override
  List<Object> get props => [settings];
}
