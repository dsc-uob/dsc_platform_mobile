import '../../../core/db/serializer.dart';
import '../domain/forms.dart';

class LoginSerializer extends MapSerializer<LoginForm> {
  LoginSerializer(LoginForm object) : super(object);

  @override
  Map<String, dynamic> generateMap() => {
        'username': object.username,
        'password': object.password,
      };
}

class RegisterSerializer extends MapSerializer<RegisterForm> {
  RegisterSerializer(RegisterForm object) : super(object);

  @override
  Map<String, dynamic> generateMap() => {
        'email': object.email,
        'first_name': object.firstName,
        'username': object.username,
        'password': object.password,
        if (object.lastName != null) 'last_name': object.lastName,
        if (object.gender != null) 'gender': object.gender,
        if (object.stage != null) 'stage': object.stage,
        if (object.bio != null) 'bio': object.bio,
      };
}

class UpdateSerializer extends MapSerializer<UpdateForm> {
  UpdateSerializer(UpdateForm object) : super(object);

  @override
  Map<String, dynamic> generateMap() => {
        if (object.email != null) 'email': object.email,
        if (object.firstName != null) 'first_name': object.firstName,
        if (object.username != null) 'username': object.username,
        if (object.password != null) 'password': object.password,
        if (object.lastName != null) 'last_name': object.lastName,
        if (object.gender != null) 'gender': object.gender,
        if (object.stage != null) 'stage': object.stage,
        if (object.bio != null) 'bio': object.bio,
        if(object.github != null) 'github': object.github,
        if(object.twitter != null) 'twitter': object.twitter,
        if(object.github != null) 'number_phone': object.numberPhone,
      };
}
