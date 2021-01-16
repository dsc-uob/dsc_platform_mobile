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

  User copyWith({
    int id,
    String username,
    String email,
    String firstName,
    bool isActive,
    bool isStaff,
    bool isSuperUser,
    String lastName,
    int gender,
    int stage,
    String bio,
    DateTime lastLogin,
    String token,
    String photo,
    String github,
    String twitter,
    String numberPhone,
  }) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        isActive: isActive ?? this.isActive,
        isStaff: isStaff ?? this.isStaff,
        isSuperUser: isSuperUser ?? this.isSuperUser,
        bio: bio ?? this.bio,
        gender: gender ?? this.gender,
        stage: stage ?? this.stage,
        lastLogin: lastLogin ?? this.lastLogin,
        token: token ?? this.token,
        photo: photo ?? this.photo,
        github: github ?? this.github,
        numberPhone: numberPhone ?? this.numberPhone,
        twitter: twitter ?? this.twitter,
      );

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
