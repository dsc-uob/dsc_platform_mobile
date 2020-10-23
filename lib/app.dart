import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/constant.dart';
import 'core/utils/app_localizations.dart';
import 'core/utils/dsc_route.dart' as route;
import 'core/utils/strings.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/user/presentation/blocs/authentication/authentication_bloc.dart';
import 'features/user/presentation/blocs/login/login_bloc.dart';
import 'features/user/presentation/blocs/user/user_bloc.dart';
import 'features/user/presentation/pages/account_page.dart';
import 'features/user/presentation/pages/login_page.dart';
import 'features/user/presentation/pages/splash_screen.dart';
import 'initial.dart';

class DSCApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (_, state) => MaterialApp(
        // locale: Locale(state.settings.langCode),
        supportedLocales: [
          Locale('ar'),
          Locale('en'),
        ],
        onGenerateTitle: (context) {
          Strings.context = context;
          return Strings.title;
        },
        onGenerateRoute: route.onGenerateRoute,
        localizationsDelegates: [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          AppLocalizations.delegate,
        ],
        theme: ThemeData(
          primaryColor: primaryColor,
          accentColor: primaryColor,
          cardColor: cardColor,
          fontFamily: state.settings.fontFamily,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryTextTheme: TextTheme(
            subtitle1: TextStyle(
              color: Colors.white70,
            ),
            subtitle2: TextStyle(
              color: Colors.white70,
            ),
          ),
          appBarTheme: AppBarTheme(
            textTheme: TextTheme(
              headline6: TextStyle(
                color: secondColor,
                fontSize: 20,
                fontFamily: state.settings.fontFamily,
              ),
            ),
            iconTheme: IconThemeData(
              color: secondColor,
            ),
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is UnauthenticatedUser) {
              return BlocProvider(
                create: (_) => LoginBloc(
                  sl(),
                  BlocProvider.of<AuthenticationBloc>(context),
                ),
                child: LoginPage(),
              );
            }
            if (state is AuthenticateUser) {
              return BlocProvider(
                create: (_) => sl<UserBloc>()..add(FetchMyAccount()),
                child: AccountPage(),
              );
            }

            return SplashScreen();
          },
        ),
      ),
    );
  }
}
