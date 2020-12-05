import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../utils/tools.dart';

class User extends Equatable {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final int gender;
  final int stage;
  final String bio;
  final bool isActive;
  final bool isStaff;
  final bool isSuperUser;
  final DateTime lastLogin;
  final String token;
  final String photo;
  final String github;
  final String twitter;
  final String numberPhone;

  const User({
    @required this.id,
    @required this.username,
    @required this.email,
    @required this.firstName,
    @required this.isActive,
    @required this.isStaff,
    @required this.isSuperUser,
    this.lastName,
    this.gender,
    this.stage,
    this.bio,
    this.lastLogin,
    this.token,
    this.photo,
    this.github,
    this.twitter,
    this.numberPhone,
  })  : assert(id != null),
        assert(username != null),
        assert(email != null),
        assert(firstName != null),
        assert(isActive != null),
        assert(isStaff != null),
        assert(isSuperUser != null);

  String get fullName => firstName + ' ' + (lastName ?? '');
  String get stringGender => getGender(gender);
  String get stringStage => getStage(stage);

  @override
  List<Object> get props => [
        id,
        username,
        email,
        firstName,
        lastName,
        gender,
        stage,
        bio,
        isActive,
        isStaff,
        isSuperUser,
        lastLogin,
        token,
        photo,
        github,
        twitter,
        numberPhone,
      ];
}
