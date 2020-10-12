import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
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
        super(SettingsInitial());

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    final currentState = state;

    if (event is FetchSettings) {
      final result = await getSettings();
      yield result.fold(
        (l) => SettingsFailed(l),
        (r) => SettingsFetched(r),
      );
    }

    if (event is ChangeLanguage && currentState is SettingsFetched) {
      final settings = Settings(
        langCode: event.langCode,
        fontFamily: currentState.settings.fontFamily,
      );
      final result = await saveSettings(settings);
      yield result.fold(
        (l) => SettingsFailed(l),
        (r) => SettingsFetched(settings),
      );
    }

    if (event is ChangeFont && currentState is SettingsFetched) {
      final settings = Settings(
        langCode: currentState.settings.langCode,
        fontFamily: event.fontFamily,
      );
      final result = await saveSettings(settings);
      yield result.fold(
        (l) => SettingsFailed(l),
        (r) => SettingsFetched(settings),
      );
    }
  }
}
