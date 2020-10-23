import 'package:dartz/dartz.dart';

import '../../../core/db/entities.dart';
import '../../../core/contrib/use_case.dart';
import '../../../core/errors/failure.dart';
import 'forms.dart';
import 'repositories.dart';

class LoginUser extends UseCase<User, LoginForm> {
  final UserRepository repository;

  LoginUser(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginForm form) => repository.login(form);
}

class ReigsterUser extends UseCase<User, RegisterForm> {
  final UserRepository repository;

  ReigsterUser(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterForm form) =>
      repository.register(form);
}

class UpdateUser extends UseCase<User, UpdateForm> {
  final UserRepository repository;

  UpdateUser(this.repository);

  @override
  Future<Either<Failure, User>> call(UpdateForm form) =>
      repository.update(form);
}

class LogoutUser extends UseCase<void, NoParams> {
  final UserRepository repository;

  LogoutUser(this.repository);

  @override
  Future<Either<Failure, void>> call([NoParams params]) => repository.logout();
}

class CurrentUser extends UseCase<User, NoParams> {
  final UserRepository repository;

  CurrentUser(this.repository);

  @override
  Future<Either<Failure, User>> call([NoParams params]) =>
      repository.currentUser();
}

class AuthenticatedUser extends UseCase<User, NoParams> {
  final UserRepository repository;

  AuthenticatedUser(this.repository);

  @override
  Future<Either<Failure, User>> call([NoParams params]) =>
      repository.isAuthenticated();
}

class GetUser extends UseCase<User, int> {
  final UserRepository repository;

  GetUser(this.repository);

  @override
  Future<Either<Failure, User>> call(int id) => repository.getUser(id);
}
