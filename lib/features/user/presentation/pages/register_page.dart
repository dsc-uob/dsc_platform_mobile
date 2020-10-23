import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/strings.dart';
import '../../../../core/utils/tools.dart';
import '../../domain/forms.dart';
import '../blocs/register/register_bloc.dart';
import '../widgets/user_text_field.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController name;
  TextEditingController username;
  TextEditingController email;
  TextEditingController password;
  TextEditingController passwordConfirm;

  FocusNode nameNode;
  FocusNode usernameNode;
  FocusNode emailNode;
  FocusNode passwordNode;
  FocusNode passwordConfirmNode;

  RegisterBloc registerBloc;

  @override
  void initState() {
    super.initState();

    registerBloc = BlocProvider.of<RegisterBloc>(context);

    name = new TextEditingController();
    email = new TextEditingController();
    username = new TextEditingController();
    password = new TextEditingController();
    passwordConfirm = new TextEditingController();

    nameNode = new FocusNode();
    emailNode = new FocusNode();
    usernameNode = new FocusNode();
    passwordNode = new FocusNode();
    passwordConfirmNode = new FocusNode();
  }

  @override
  void dispose() {
    registerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Strings.context = context;
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height + 100,
            child: BlocListener<RegisterBloc, RegisterState>(
              listener: (context, state) {
                if (state is RegisterSuccessfuly) {
                  FlushbarHelper.createSuccess(
                    title: Strings.register,
                    message: '${Strings.welcome} ${state.user.firstName}',
                  )
                    ..dismiss()
                    ..show(context);
                }
                if (state is RegisterFailed) {
                  FlushbarHelper.createError(
                    title: Strings.register,
                    message: Strings.registerFailed,
                  )..show(context);
                }
                if (state is LoadRegisterAccount) {
                  FlushbarHelper.createLoading(
                    title: Strings.register,
                    message: Strings.pleaseWait,
                    progressIndicatorBackgroundColor:
                        Theme.of(context).accentColor,
                    linearProgressIndicator: LinearProgressIndicator(),
                  )..show(context);
                }
              },
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: SvgPicture.asset(
                      'assets/images/join.svg',
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
                            hintText: Strings.enterName,
                            icon: Icons.person,
                            controller: name,
                            focusNode: nameNode,
                            inputType: TextInputType.text,
                            action: TextInputAction.next,
                            validator: (value) {
                              if (value.isEmpty || value.trim() == '')
                                return Strings.dontLetFieldEmpty;
                              return null;
                            },
                          ),
                          UserTextField(
                            hintText: Strings.enterUsername,
                            icon: Icons.person_pin,
                            controller: username,
                            focusNode: usernameNode,
                            inputType: TextInputType.text,
                            action: TextInputAction.next,
                            validator: (value) {
                              final validState = validateUsername(value);

                              if (validState == UserNameValidation.Invalid)
                                return Strings.enterValidUsername;
                              return null;
                            },
                          ),
                          UserTextField(
                            hintText: Strings.enterEmail,
                            icon: Icons.email,
                            controller: email,
                            focusNode: emailNode,
                            inputType: TextInputType.emailAddress,
                            action: TextInputAction.next,
                            validator: (value) {
                              final validState = validateEmail(value);

                              if (validState == EmailValidation.Invalid)
                                return Strings.enterValidEmail;
                              return null;
                            },
                          ),
                          UserTextField(
                            hintText: Strings.enterPassword,
                            icon: Icons.lock,
                            controller: password,
                            focusNode: passwordNode,
                            inputType: TextInputType.text,
                            action: TextInputAction.next,
                            isPassword: true,
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
                          UserTextField(
                            hintText: Strings.enterPasswordConfirm,
                            icon: Icons.lock,
                            controller: passwordConfirm,
                            focusNode: passwordConfirmNode,
                            inputType: TextInputType.text,
                            action: TextInputAction.done,
                            isPassword: true,
                            validator: (value) {
                              if (value.isEmpty || value.trim() == '')
                                return Strings.dontLetFieldEmpty;

                              if (value != password.text)
                                return Strings.passwordConfirmIncorrect;

                              return null;
                            },
                          ),
                          RaisedButton(
                            child: Text(Strings.register),
                            color: Theme.of(context).accentColor,
                            textColor: Colors.white,
                            onPressed: registerClick,
                          ),
                          FlatButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: SvgPicture.asset(
                              'assets/images/login.svg',
                              width: 40,
                              height: 30,
                            ),
                            label: Text(Strings.login),
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

  void registerClick() {
    final isValidate = _formKey.currentState.validate();
    if (isValidate)
      registerBloc.add(
        RegisterEvent(RegisterForm(
          email: email.text.trim(),
          username: username.text.trim(),
          password: password.text,
          firstName: name.text.trim(),
        )),
      );
    else
      FlushbarHelper.createError(
        title: Strings.register,
        message: Strings.enterValidData,
      )..show(context);
  }
}
