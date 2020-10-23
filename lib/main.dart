import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/user/presentation/blocs/authentication/authentication_bloc.dart';
import 'initial.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  Bloc.observer = new DSCBlocObserver();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (_) => sl<AuthenticationBloc>()..add(CheckAuthentication()),
        ),
        BlocProvider<SettingsBloc>(
          create: (_) => sl<SettingsBloc>()..add(FetchSettings()),
        ),
      ],
      child: DSCApp(),
    ),
  );
}

class DSCBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stacktrace) {
    super.onError(cubit, error, stacktrace);
    print(error);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}
