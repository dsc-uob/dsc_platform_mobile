import 'package:dartz/dartz.dart';

import '../../../core/contrib/repository.dart';
import '../../../core/db/entities.dart';
import '../../../core/errors/failure.dart';
import 'forms.dart';

abstract class UserRepository extends Repository {
  Future<Either<Failure, User>> login(LoginForm form);
  Future<Either<Failure, User>> register(RegisterForm form);
  Future<Either<Failure, User>> update(UpdateForm form);
  Future<Either<Failure, User>> getUser(int id);
  Future<Either<Failure, User>> currentUser();
  Future<Either<Failure, User>> isAuthenticated();
  Future<Either<Failure, void>> logout();
}
