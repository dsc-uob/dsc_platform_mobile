import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/constant.dart';
import 'core/db/entities.dart';
import 'core/utils/app_localizations.dart';
import 'core/utils/dsc_route.dart' as route;
import 'core/utils/strings.dart';
import 'features/post/presentation/blocs/post/post_bloc.dart';
import 'features/post/presentation/pages/post_page.dart';
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
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: primaryColor,
            selectionColor: statusBarColor.withOpacity(0.2),
            selectionHandleColor: statusBarColor,
          ),
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
            color: primaryColor,
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
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) => sl<UserBloc>()..add(FetchMyAccount()),
                  ),
                ],
                child: HomeScreen(
                  user: state.user,
                ),
              );
            }

            return SplashScreen();
          },
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({
    Key key,
    @required this.user,
  })  : assert(user != null),
        super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPage;
  List<Widget> screens;

  User get user => widget.user;

  @override
  void initState() {
    super.initState();
    currentPage = 1;
    screens = [
      BlocProvider<PostBloc>(
        create: (context) => sl<PostBloc>()..add(FetchPosts()),
        child: PostPage(),
      ),
      Container(
        child: BlocProvider<PostBloc>(
          create: (context) => sl<PostBloc>()..add(FetchUserPosts(user.id)),
          child: AccountPage(),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Strings.context = context;
    return Scaffold(
      body: screens[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: Strings.posts,
            icon: Icon(Icons.description),
          ),
          BottomNavigationBarItem(
            label: Strings.myAccount,
            icon: Icon(Icons.person),
          ),
        ],
        currentIndex: currentPage,
        onTap: (page) => setState(() => currentPage = page),
      ),
    );
  }
}
