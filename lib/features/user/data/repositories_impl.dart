import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/db/entities.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failure.dart';
import '../../../core/utils/network_info.dart';
import '../domain/forms.dart';
import '../domain/repositories.dart';
import 'data_sources.dart';
import 'serializers.dart';

class UserRepositoryImpl extends UserRepository {
  final NetworkInfo networkInfo;
  final LocalUserDataSource localDS;
  final RemoteUserDataSource remoteDS;

  UserRepositoryImpl({
    @required this.networkInfo,
    @required this.localDS,
    @required this.remoteDS,
  })  : assert(networkInfo != null),
        assert(localDS != null),
        assert(remoteDS != null);

  @override
  Future<void> setup() async {
    if (!prepared) {
      await localDS.setup();
      await remoteDS.setup();
      await networkInfo.setup();
      prepared = true;
    }
  }

  @override
  Future<void> dispose() async {
    await localDS.dispose();
    await remoteDS.dispose();
    await networkInfo.dispose();
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDS.me();
        localDS.storeUser(user);
        return Right(user);
      } on NoUserLoginException {
        return Left(NoUserLoginFailure('No user found!'));
      } on UnknownException {
        return Left(UnknownFailure('Unknown failure.'));
      } catch (_) {
        return Left(UnknownFailure('Unknown failure.'));
      }
    } else {
      try {
        final user = await localDS.getCurrentUser();
        return Right(user);
      } on NoUserLoginException {
        return Left(NoUserLoginFailure('No user login.'));
      } catch (_) {
        return Left(UnknownFailure('Unknown failure.'));
      }
    }
  }

  @override
  Future<Either<Failure, User>> getUser(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDS.getUser(id);
        return Right(user);
      } on UnknownException {
        return Left(UnknownFailure('Unknown failure.'));
      }
    }
    return Left(InternetConnectionFailure('No Internet connection.'));
  }

  @override
  Future<Either<Failure, User>> login(LoginForm form) async {
    try {
      final user = await remoteDS.login(LoginSerializer(form));
      localDS.storeUser(user).then((value) => print('User session saved!'));
      return Right(user);
    } catch (_) {
      return Left(UnknownFailure('Unknown failure.'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      return Right(await localDS.logout());
    } catch (_) {
      return Left(UnknownFailure('Unknown failure.'));
    }
  }

  @override
  Future<Either<Failure, User>> register(RegisterForm form) async {
    try {
      final user = await remoteDS.register(RegisterSerializer(form));
      return Right(user);
    } catch (_) {
      return Left(UnknownFailure('Error with register.'));
    }
  }

  @override
  Future<Either<Failure, User>> update(UpdateForm form) async {
    try {
      final user = await remoteDS.update(UpdateSerializer(form));
      localDS.storeUser(user);
      return Right(user);
    } catch (_) {
      return Left(UnknownFailure('Error with update.'));
    }
  }

  @override
  Future<Either<Failure, User>> isAuthenticated() async {
    try {
      final user = await localDS.getCurrentUser();
      return Right(user);
    } on NoUserLoginException {
      return Left(NoUserLoginFailure('No user found!'));
    } catch (_) {
      return Left(UnknownFailure('$_'));
    }
  }
}
