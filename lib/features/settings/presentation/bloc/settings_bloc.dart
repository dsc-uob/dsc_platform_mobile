import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../domain/entities.dart';
import '../../domain/usecases.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettings getSettings;
  final SaveSettings saveSettings;

  SettingsBloc({
    @required this.getSettings,
    @required this.saveSettings,
  })  : assert(getSettings != null),
        assert(saveSettings != null),
        super(SettingsState.defaultSettings());

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    final currentState = state;

    if (event is FetchSettings) {
      final result = await getSettings();
      yield result.fold(
        (l) => SettingsState.defaultSettings(),
        (r) => SettingsState(r),
      );
    }

    if (event is ChangeLanguage) {
      final settings = Settings(
        langCode: event.langCode,
        fontFamily: currentState.settings.fontFamily,
      );
      final result = await saveSettings(settings);
      yield result.fold(
        (l) => SettingsState.defaultSettings(),
        (r) => SettingsState(settings),
      );
    }

    if (event is ChangeFont) {
      final settings = Settings(
        langCode: currentState.settings.langCode,
        fontFamily: event.fontFamily,
      );
      final result = await saveSettings(settings);
      yield result.fold(
        (l) => SettingsState.defaultSettings(),
        (r) => SettingsState(settings),
      );
    }
  }
}
