part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsFetched extends SettingsState {
  final Settings settings;

  const SettingsFetched(this.settings);

  @override
  List<Object> get props => [settings];
}

class SettingsFailed extends SettingsState {
  final Failure failure;

  const SettingsFailed(this.failure);

  @override
  List<Object> get props => [failure];
}
