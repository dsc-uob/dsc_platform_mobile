import 'strings.dart';

//! Validation
enum EmailValidation {
  Invalid,
  Currect,
}

enum PasswordValidation {
  Invalid,
  Must_Longer_Than_5,
  Must_Have_Chars_Numbers,
  Currect,
}

enum UserNameValidation {
  Invalid,
  Currect,
}

EmailValidation validateEmail(String value) {
  if (value == null) return EmailValidation.Invalid;
  if (value.isEmpty) return EmailValidation.Invalid;
  if (value.length < 6) return EmailValidation.Invalid;

  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return (regex.hasMatch(value))
      ? EmailValidation.Currect
      : EmailValidation.Invalid;
}

PasswordValidation validatePassword(String value) {
  if (value == null) return PasswordValidation.Invalid;
  if (value.isEmpty) return PasswordValidation.Invalid;
  if (value.length < 6) return PasswordValidation.Must_Longer_Than_5;

  String pattern = r'^(?=.*?[A-Za-z-!@#\$&*~])(?=.*?[0-9]).{6,}$';

  final _passwordRegExp = RegExp(pattern);

  return _passwordRegExp.hasMatch(value)
      ? PasswordValidation.Currect
      : PasswordValidation.Must_Have_Chars_Numbers;
}

UserNameValidation validateUsername(String value) {
  if (value == null) return UserNameValidation.Invalid;
  if (value.isEmpty) return UserNameValidation.Invalid;
  if (value.length < 3) return UserNameValidation.Invalid;

  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))$';
  RegExp regex = new RegExp(pattern);
  return (regex.hasMatch(value))
      ? UserNameValidation.Currect
      : UserNameValidation.Invalid;
}

//! Others
String getGender(int gender) {
  switch (gender) {
    case 0:
      return Strings.male;
      break;
    case 1:
      return Strings.female;
      break;
    default:
      return Strings.undefined;
  }
}

String getStage(int gender) {
  switch (gender) {
    case 1:
      return Strings.first;
      break;
    case 2:
      return Strings.second;
      break;
    case 3:
      return Strings.third;
      break;
    case 4:
      return Strings.forth;
      break;
    case 5:
      return Strings.fifth;
      break;
    case 6:
      return Strings.sixth;
      break;
    default:
      return Strings.undefined;
  }
}
