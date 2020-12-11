import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constant.dart';
import '../../../../core/db/entities.dart';
import '../../../../core/utils/strings.dart';
import '../../../../core/utils/tools.dart';
import '../../domain/forms.dart';
import '../blocs/user/user_bloc.dart';
import '../widgets/user_text_field.dart';

class UserFormPage extends StatefulWidget {
  final User user;

  const UserFormPage({
    Key key,
    @required this.user,
  })  : assert(user != null),
        super(key: key);

  @override
  _UserFormPageState createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final formKey = new GlobalKey<FormState>();

  TextEditingController firstName;
  TextEditingController lastName;
  TextEditingController username;
  TextEditingController email;
  TextEditingController password;
  TextEditingController bio;
  TextEditingController github;
  TextEditingController numberPhone;
  TextEditingController twitter;

  FocusNode firstNameNode;
  FocusNode lastNameNode;
  FocusNode usernameNode;
  FocusNode emailNode;
  FocusNode passwordNode;
  FocusNode bioNode;
  FocusNode githubNode;
  FocusNode numberPhoneNode;
  FocusNode twitterNode;

  int stage = -1;
  int gender = -1;

  UserBloc userBloc;
  User user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    userBloc = BlocProvider.of<UserBloc>(context);

    firstName = new TextEditingController(text: user.firstName);
    lastName = new TextEditingController(text: user.lastName);
    username = new TextEditingController(text: user.username);
    password = new TextEditingController();
    email = new TextEditingController(text: user.email);
    bio = new TextEditingController(text: user.bio);
    password = new TextEditingController();
    github = new TextEditingController(text: user.github);
    numberPhone = new TextEditingController(text: user.numberPhone);
    twitter = new TextEditingController(text: user.twitter);
    stage = user.stage ?? -1;
    gender = user.gender ?? -1;

    firstNameNode = new FocusNode();
    lastNameNode = new FocusNode();
    usernameNode = new FocusNode();
    passwordNode = new FocusNode();
    emailNode = new FocusNode();
    bioNode = new FocusNode();
    githubNode = new FocusNode();
    numberPhoneNode = new FocusNode();
    twitterNode = new FocusNode();
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    username.dispose();
    password.dispose();
    bio.dispose();
    github.dispose();
    numberPhone.dispose();
    twitter.dispose();

    firstNameNode.dispose();
    lastNameNode.dispose();
    emailNode.dispose();
    usernameNode.dispose();
    passwordNode.dispose();
    bioNode.dispose();
    githubNode.dispose();
    twitterNode.dispose();
    numberPhoneNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Strings.editAccount,
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state is SuccessUpdateAccount) {
              FlushbarHelper.createSuccess(
                title: Strings.update,
                message: Strings.dataSuccessfulUpdate,
              )..show(context);
              user = state.user;
              _updateFormData();
            }
            if (state is LoadUpdateAccount) {
              FlushbarHelper.createLoading(
                title: Strings.update,
                message: Strings.pleaseWait,
                linearProgressIndicator: LinearProgressIndicator(),
              )..show(context);
            }
            if (state is FieldUpdateAccount) {
              FlushbarHelper.createLoading(
                title: Strings.update,
                message: Strings.dataFailedUpdated,
                linearProgressIndicator: LinearProgressIndicator(),
              )..show(context);
            }
          },
          builder: (context, state) {
            if (state is SuccessFetchAccount)
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        margin: const EdgeInsets.all(16),
                        child: CircleAvatar(
                          backgroundColor: secondColor,
                          child:
                              SvgPicture.asset('assets/images/profile_pic.svg'),
                        ),
                      ),
                      UserTextField(
                        action: TextInputAction.next,
                        controller: firstName,
                        focusNode: firstNameNode,
                        hintText: Strings.firstName,
                        icon: Icons.person,
                        inputType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty || value.trim() == '')
                            return Strings.dontLetFieldEmpty;
                          return null;
                        },
                      ),
                      UserTextField(
                        action: TextInputAction.next,
                        controller: lastName,
                        focusNode: lastNameNode,
                        hintText: Strings.lastName,
                        icon: Icons.family_restroom,
                        inputType: TextInputType.text,
                      ),
                      UserTextField(
                        controller: username,
                        focusNode: usernameNode,
                        hintText: Strings.username,
                        icon: Icons.person_pin,
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
                        action: TextInputAction.next,
                        controller: email,
                        focusNode: emailNode,
                        hintText: Strings.email,
                        icon: Icons.email,
                        inputType: TextInputType.emailAddress,
                        validator: (value) {
                          final validState = validateEmail(value);

                          if (validState == EmailValidation.Invalid)
                            return Strings.enterValidEmail;
                          return null;
                        },
                      ),
                      UserTextField(
                        action: TextInputAction.next,
                        controller: password,
                        focusNode: passwordNode,
                        hintText: Strings.password,
                        icon: Icons.lock,
                        inputType: TextInputType.text,
                        isPassword: true,
                        validator: (value) {
                          if (value.isEmpty) return null;

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
                        controller: github,
                        focusNode: githubNode,
                        hintText: 'GitHub',
                        icon: Icons.alternate_email,
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
                        controller: twitter,
                        focusNode: twitterNode,
                        hintText: 'Twitter',
                        icon: Icons.alternate_email,
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
                        controller: numberPhone,
                        focusNode: numberPhoneNode,
                        hintText: 'Whatsapp',
                        icon: Icons.phone,
                        inputType: TextInputType.text,
                        action: TextInputAction.next,
                      ),
                      Container(
                        margin: const EdgeInsets.all(5),
                        child: DropdownButton<int>(
                          isExpanded: true,
                          hint: Text("${Strings.stage}: ${getStage(stage)}"),
                          items: List<DropdownMenuItem<int>>.generate(
                            6,
                            (index) => DropdownMenuItem<int>(
                              child: Text(getStage(index + 1)),
                              value: index + 1,
                            ),
                          ),
                          onChanged: (value) => setState(() => stage = value),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(5),
                        child: DropdownButton<int>(
                          isExpanded: true,
                          hint: Text("${Strings.gender}: ${getGender(gender)}"),
                          items: List<DropdownMenuItem<int>>.generate(
                            2,
                            (index) => DropdownMenuItem<int>(
                              child: Text(getGender(index)),
                              value: index,
                            ),
                          ),
                          onChanged: (value) => setState(() => gender = value),
                        ),
                      ),
                      UserTextField(
                        action: TextInputAction.done,
                        controller: bio,
                        focusNode: bioNode,
                        hintText: Strings.bio,
                        icon: Icons.description,
                        inputType: TextInputType.multiline,
                      ),
                      RaisedButton(
                        child: Text(Strings.update),
                        color: Theme.of(context).accentColor,
                        textColor: Colors.white,
                        onPressed: _update,
                      ),
                    ],
                  ),
                ),
              );

            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  void _update() {
    if (formKey.currentState.validate()) {
      userBloc.add(
        UpdateMyAccount(UpdateForm(
          firstName: firstName.text.trim() != user.firstName
              ? firstName.text.trim()
              : null,
          lastName: lastName.text.trim() != user.lastName
              ? lastName.text.trim()
              : null,
          email: email.text.trim() != user.email ? email.text.trim() : null,
          username: username.text.trim() != user.username
              ? username.text.trim()
              : null,
          github: github.text.trim() != user.github ? github.text.trim() : null,
          twitter:
              twitter.text.trim() != user.twitter ? twitter.text.trim() : null,
          numberPhone: numberPhone.text.trim() != user.numberPhone
              ? numberPhone.text.trim()
              : null,
          password: password.text.trim().isNotEmpty ? password.text : null,
          bio: bio.text != user.bio ? bio.text.trim() : null,
          gender: gender != user.gender ? gender : null,
          stage: stage != user.stage ? stage : null,
        )),
      );
    } else {
      FlushbarHelper.createError(
        title: Strings.update,
        message: Strings.enterValidData,
      )..show(context);
    }
  }

  void _updateFormData() {
    firstName.text = user.firstName;
    lastName.text = user.lastName;
    username.text = user.username;
    email.text = user.email;
    bio.text = user.bio;
    stage = user.stage;
    gender = user.gender;
  }
}
