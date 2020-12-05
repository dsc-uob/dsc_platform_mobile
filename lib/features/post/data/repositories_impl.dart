import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/contrib/use_case.dart';
import '../../../core/db/serializer.dart';
import '../../../core/errors/failure.dart';
import '../../../core/utils/network_info.dart';
import '../domain/entities.dart';
import '../domain/forms.dart';
import '../domain/repositories.dart';
import 'data_sources.dart';
import 'models.dart';
import 'serializers.dart';

class PostRepositoryImpl extends PostRepository {
  final NetworkInfo networkInfo;
  final PostLocalDataSource localDataSource;
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl({
    @required this.networkInfo,
    @required this.localDataSource,
    @required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<Post>>> get(LimitOffsetPagination page) async {
    try {
      if (await networkInfo.isConnected) {
        final res = await remoteDataSource.get(page);
        final ls = ListSerializer<PostModel>(res);
        localDataSource.cache(ls);
        return Right(res);
      } else {
        final res = await localDataSource.get();
        return Right(res);
      }
    } catch (_) {
      return Left(UnknownFailure('$_'));
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getUserPost(UserPostsParams page) async {
    try {
      final key = 'USER_${page.user}_POST';
      if (await networkInfo.isConnected) {
        final res = await remoteDataSource.getUserPost(page);
        final ls = ListSerializer<PostModel>(res, key: key);
        localDataSource.cache(ls);
        return Right(res);
      } else {
        final res = await localDataSource.get(key);
        return Right(res);
      }
    } catch (_) {
      return Right([]);
    }
  }

  @override
  Future<Either<Failure, Post>> add(CreatePostForm form) async {
    try {
      if (await networkInfo.isConnected) {
        final res = await remoteDataSource.add(CreatePostSerializer(form));
        return Right(res);
      } else {
        return Left(NoInternetFailure());
      }
    } catch (_) {
      return Left(UnknownFailure('$_'));
    }
  }

  @override
  Future<Either<Failure, Post>> update(UpdatePostForm form) async {
    try {
      if (await networkInfo.isConnected) {
        final res = await remoteDataSource.update(UpdatePostSerializer(form));
        return Right(res);
      } else {
        return Left(NoInternetFailure());
      }
    } catch (_) {
      return Left(UnknownFailure('$_'));
    }
  }

  @override
  Future<Either<Failure, void>> delete(int id) async {
    try {
      if (await networkInfo.isConnected) {
        final res = await remoteDataSource.delete(id);
        return Right(res);
      } else {
        return Left(NoInternetFailure());
      }
    } catch (_) {
      return Left(UnknownFailure('$_'));
    }
  }
}

class CommentRepositoryImpl extends CommentRepository {
  final NetworkInfo networkInfo;
  final CommentLocalDataSource localDataSource;
  final CommentRemoteDataSource remoteDataSource;

  CommentRepositoryImpl({
    @required this.networkInfo,
    @required this.localDataSource,
    @required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, Comment>> add(CreateCommentForm form) async {
    if (await networkInfo.isConnected) {
      try {
        final res = await remoteDataSource.add(CreateCommentSerializer(form));
        return Right(res);
      } catch (_) {
        return Left(UnknownFailure('$_'));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, void>> delete(int id, int postId) async {
    if (await networkInfo.isConnected) {
      try {
        final res = await remoteDataSource.delete(id, postId);
        return Right(res);
      } catch (_) {
        return Left(UnknownFailure('$_'));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, List<Comment>>> get(CommentsFetchParams page) async {
    try {
      if (await networkInfo.isConnected) {
        final res = await remoteDataSource.get(page);
        localDataSource.cache(
          ListSerializer(
            res,
            key: 'COMMENTS_${page.post}',
          ),
        );
        return Right(res);
      } else {
        final res = await localDataSource.get(page.post);
        return Right(res);
      }
    } catch (_) {
      return Left(UnknownFailure('$_'));
    }
  }

  @override
  Future<Either<Failure, List<Comment>>> getThis(
    int id,
    int postId,
  ) async {}

  @override
  Future<Either<Failure, Comment>> update(
    int id,
    int postId,
    UpdateCommentForm form,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        final res = await remoteDataSource.update(
            id, postId, UpdateCommentSerializer(form));
        return Right(res);
      } else {
        return Left(NoInternetFailure());
      }
    } catch (_) {
      return Left(UnknownFailure('$_'));
    }
  }
}
