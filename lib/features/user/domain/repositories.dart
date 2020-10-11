import 'package:dartz/dartz.dart';

import '../../../core/bases/entities.dart';
import '../../../core/errors/failure.dart';
import 'forms.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> login(LoginForm form);
  Future<Either<Failure, User>> register(RegisterForm form);
  Future<Either<Failure, User>> update(UpdateForm form);
  Future<Either<Failure, User>> getUser(int id);
  Future<Either<Failure, User>> currentUser();
  Future<Either<Failure, void>> logout();
}
