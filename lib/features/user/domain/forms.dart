import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class LoginForm extends Equatable {
  /// We can use username or email.
  final String username;
  final String password;

  const LoginForm(this.username, this.password);

  @override
  List<Object> get props => [username, password];
}

class RegisterForm extends Equatable {
  /// Required fields
  final String email;
  final String username;
  final String password;
  final String firstName;

  /// Optional fields.
  final String lastName;
  final int gender;
  final int stage;
  final String bio;

  const RegisterForm({
    @required this.email,
    @required this.username,
    @required this.password,
    @required this.firstName,
    this.lastName,
    this.gender,
    this.stage,
    this.bio,
  })  : assert(email != null),
        assert(username != null),
        assert(password != null),
        assert(firstName != null);

  @override
  List<Object> get props => [
        email,
        username,
        password,
        firstName,
        lastName,
        gender,
        stage,
        bio,
      ];
}

class UpdateForm extends Equatable {
  final String email;
  final String username;
  final String password;
  final String firstName;
  final String lastName;
  final int gender;
  final int stage;
  final String bio;
  final String github;
  final String twitter;
  final String numberPhone;

  const UpdateForm({
    this.email,
    this.username,
    this.password,
    this.firstName,
    this.lastName,
    this.gender,
    this.stage,
    this.bio,
    this.github,
    this.twitter,
    this.numberPhone,
  });

  @override
  List<Object> get props => [
        email,
        username,
        password,
        firstName,
        lastName,
        gender,
        stage,
        bio,
        github,
        twitter,
        numberPhone,
      ];
}
