import 'package:dartz/dartz.dart';

import '../../../core/contrib/repository.dart';
import '../../../core/contrib/use_case.dart';
import '../../../core/errors/failure.dart';
import 'entities.dart';
import 'forms.dart';

abstract class PostRepository extends Repository {
  Future<Either<Failure, List<Post>>> get(LimitOffsetPagination page);
  Future<Either<Failure, List<Post>>> getUserPost(IdLimitOffsetParams page);
  Future<Either<Failure, Post>> add(CreatePostForm form);
  Future<Either<Failure, Post>> update(UpdatePostForm form);
  Future<Either<Failure, void>> delete(int id);
}

abstract class CommentRepository extends Repository {
  Future<Either<Failure, List<Comment>>> get(IdLimitOffsetParams page);
  Future<Either<Failure, List<Comment>>> getThis(int id, int postId);
  Future<Either<Failure, Comment>> add(CreateCommentForm form);
  Future<Either<Failure, Comment>> update(
      int id, int postId, UpdateCommentForm form);
  Future<Either<Failure, void>> delete(int id, int postId);
}
