import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constant.dart';
import '../../../../core/utils/dsc_route.dart' as route;
import '../../../../core/utils/strings.dart';
import '../../../../core/utils/tools.dart';
import '../../domain/forms.dart';
import '../blocs/login/login_bloc.dart';
import '../widgets/user_text_field.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool run = true;
  TextEditingController email;
  TextEditingController password;

  FocusNode emailNode;
  FocusNode passwordNode;

  LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    email = new TextEditingController();
    password = new TextEditingController();

    emailNode = new FocusNode();
    passwordNode = new FocusNode();

    loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    loginBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Strings.context = context;
    setStatusBarColor(StatusBarState.Opacity);
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoadLoginAccount) {
              FlushbarHelper.createLoading(
                title: Strings.login,
                message: Strings.pleaseWait,
                progressIndicatorBackgroundColor: Theme.of(context).accentColor,
                linearProgressIndicator: LinearProgressIndicator(),
              )..show(context);
            }
            if (state is LoginFailed) {
              FlushbarHelper.createError(
                title: Strings.login,
                message: Strings.loginFailed,
              )
                ..dismiss()
                ..show(context);
            }
            if (state is LoginSuccessful) {
              FlushbarHelper.createSuccess(
                title: Strings.login,
                message: '${Strings.welcome} ${state.user.firstName}',
              )
                ..dismiss()
                ..show(context);
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 4,
                    child: SvgPicture.asset(
                      'assets/images/welcome.svg',
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.always,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          UserTextField(
                            hintText: Strings.enterEmail,
                            icon: Icons.email,
                            controller: email,
                            focusNode: emailNode,
                            inputType: TextInputType.emailAddress,
                            action: TextInputAction.next,
                            validator: (value) {
                              var validation;
                              if (value.contains('@'))
                                validation = validateEmail(value);
                              else
                                validation = validateUsername(value);

                              if (validation != null) {
                                if (validation == EmailValidation.Invalid)
                                  return Strings.enterValidEmail;
                                if (validation == UserNameValidation.Invalid)
                                  return Strings.enterValidUsername;
                              }
                              if (value.isEmpty) return Strings.enterValidEmail;

                              return null;
                            },
                          ),
                          UserTextField(
                            hintText: Strings.enterPassword,
                            icon: Icons.lock,
                            controller: password,
                            focusNode: passwordNode,
                            inputType: TextInputType.text,
                            action: TextInputAction.done,
                            isPassword: true,
                            onSubmitted: _login,
                            validator: (value) {
                              final validState = validatePassword(value);

                              if (validState == PasswordValidation.Invalid)
                                return Strings.enterValidPassword;
                              if (validState ==
                                  PasswordValidation.Must_Have_Chars_Numbers)
                                return Strings.mustHaveCharsNumbers;
                              if (validState ==
                                  PasswordValidation.Must_Longer_Than_5)
                                return Strings.mustLongerThan5;

                              return null;
                            },
                          ),
                          RaisedButton(
                            child: Text(Strings.login),
                            color: Theme.of(context).accentColor,
                            textColor: Colors.white,
                            onPressed: _login,
                          ),
                          FlatButton.icon(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              route.register,
                            ),
                            icon: SvgPicture.asset(
                              'assets/images/join.svg',
                              width: 40,
                              height: 30,
                            ),
                            label: Text(Strings.joinUs),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login() {
    final loginForm = LoginForm(
      email.text.trim(),
      password.text,
    );

    loginBloc.add(LoginEvent(loginForm));
  }
}
