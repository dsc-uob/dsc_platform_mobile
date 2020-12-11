import 'package:dartz/dartz.dart';

import '../../../core/contrib/use_case.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failure.dart';
import '../../../core/utils/network_info.dart';
import '../domain/entities.dart';
import '../domain/repositories.dart';
import 'data_sources.dart';

class ImageRepositoryImpl extends ImageRepository {
  final NetworkInfo networkInfo;
  final ImageLocalDataSource localDataSource;
  final ImageRemoteDataSource remoteDataSource;

  ImageRepositoryImpl({
    this.networkInfo,
    this.remoteDataSource,
    this.localDataSource,
  });

  @override
  Future<Either<Failure, void>> delete(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final res = await remoteDataSource.deleteImage(id);
        return Right(res);
      } catch (_) {
        if (_ is UnknownException) return Left(UnknownFailure(_.details));
        return Left(UnknownFailure('$_'));
      }
    }
    return Left(NoInternetFailure());
  }

  @override
  Future<Either<Failure, List<DImage>>> fetchUserPost(
      IdLimitOffsetParams params) async {
    try {
      if (await networkInfo.isConnected) {
        final res = await remoteDataSource.getUserImage(params);
        return Right(res);
      } else {
        final res = await localDataSource.getUserImage(params.id);
        return Right(res);
      }
    } on CacheManagerException {
      return Right([]);
    } catch (_) {
      return Left(UnknownFailure('$_'));
    }
  }
}
