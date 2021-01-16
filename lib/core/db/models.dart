import 'package:meta/meta.dart';

import '../api_routes.dart';
import 'entities.dart';
import 'serializer.dart';

class UserModel extends User implements MapSerializer {
  const UserModel({
    @required int id,
    @required String username,
    @required String email,
    @required String firstName,
    @required bool isActive,
    @required bool isStaff,
    @required bool isSuperUser,
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
  }) : super(
          id: id,
          username: username,
          email: email,
          firstName: firstName,
          lastName: lastName,
          isActive: isActive,
          isStaff: isStaff,
          isSuperUser: isSuperUser,
          token: token,
          lastLogin: lastLogin,
          bio: bio,
          gender: gender,
          stage: stage,
          photo: photo,
          github: github,
          twitter: twitter,
          numberPhone: numberPhone,
        );

  factory UserModel.fromJson(Map<String, dynamic> data) {
    DateTime lastLogin;
    if (data['last_login'] != null)
      lastLogin = DateTime.parse(data['last_login']).toLocal();

    String url = data['photo'];
    if (url != null && !url.startsWith('https')) url = api_url + url;

    return UserModel(
      id: data['id'],
      username: data['username'],
      email: data['email'],
      firstName: data['first_name'],
      lastName: data['last_name'],
      bio: data['bio'],
      gender: data['gender'],
      stage: data['stage'],
      isActive: data['is_active'],
      isStaff: data['is_staff'],
      isSuperUser: data['is_superuser'],
      lastLogin: lastLogin,
      token: data['token'],
      photo: url,
      github: data['github'],
      twitter: data['twitter'],
      numberPhone: data['number_phone'],
    );
  }

  UserModel setToken(String token) => copyWith(token: token);

  UserModel copyWith({
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
      UserModel(
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
  Map<String, dynamic> generateMap() => {
        "id": id,
        "username": username,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "is_active": isActive,
        "is_staff": isStaff,
        "is_superuser": isSuperUser,
        "gender": gender,
        "stage": stage,
        "last_login": lastLogin.toString(),
        "bio": bio,
        "photo": photo,
        "github": github,
        "twitter": twitter,
        "number_phone": numberPhone,
      };

  @override
  get object => this;
}
