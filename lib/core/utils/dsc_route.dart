import 'package:dsc_platform/features/post/presentation/blocs/comment/comment_bloc.dart';
import 'package:dsc_platform/features/post/presentation/blocs/post/post_bloc.dart';
import 'package:dsc_platform/features/post/presentation/pages/comments_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../features/post/presentation/pages/post_form_page.dart';
import '../../features/post/presentation/pages/post_viewer_page.dart';
import '../../features/user/presentation/blocs/login/login_bloc.dart';
import '../../features/user/presentation/blocs/register/register_bloc.dart';
import '../../features/user/presentation/blocs/user/user_bloc.dart';
import '../../features/user/presentation/pages/account_page.dart';
import '../../features/user/presentation/pages/login_page.dart';
import '../../features/user/presentation/pages/register_page.dart';
import '../../features/user/presentation/pages/user_form_page.dart';
import '../../initial.dart';
import 'strings.dart';

const login = '/login';
const register = '/register';
const account = '/account';
const user_form = '/user_form';
const post_form = '/post_form';
const post_view = '/post_view';
const comment_page = '/comment_page';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  final args = settings.arguments;

  switch (settings.name) {
    case login:
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<LoginBloc>(),
          child: LoginPage(),
        ),
      );
      break;
    case register:
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<RegisterBloc>(),
          child: RegisterPage(),
        ),
      );
      break;
    case account:
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<UserBloc>()..add(FetchMyAccount()),
          child: AccountPage(),
        ),
      );
    case user_form:
      if (args is Map)
        return MaterialPageRoute(
          builder: (_) => BlocProvider<UserBloc>.value(
            value: BlocProvider.of<UserBloc>(args['context']),
            child: UserFormPage(
              user: args['user'],
            ),
          ),
        );
      break;
    case post_view:
      return MaterialPageRoute(
        builder: (_) => PostViewerPage(
          post: args,
        ),
      );
    case post_form:
      return MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: BlocProvider.of<PostBloc>(args),
          child: PostFormPage(),
        ),
      );
    case comment_page:
      return MaterialPageRoute(
        builder: (_) => BlocProvider<CommentBloc>(
          create: (_) => sl<CommentBloc>()..add(FetchComments(args)),
          child: CommentsPage(),
        ),
      );
    default:
      return MaterialPageRoute(builder: (_) => ErrorPage());
  }
  return MaterialPageRoute(builder: (_) => ErrorPage());
}

class ErrorPage extends StatefulWidget {
  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    Strings.context = context;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(Strings.notFound),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/not_found.svg',
            height: 300,
          ),
          Text(
            Strings.notFound,
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );
  }
}
