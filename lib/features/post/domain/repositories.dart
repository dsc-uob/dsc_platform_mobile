import 'package:dartz/dartz.dart';

import '../../../core/contrib/repository.dart';
import '../../../core/errors/failure.dart';
import 'entities.dart';
import 'forms.dart';

abstract class PostRepository extends Repository {
  Future<Either<Failure, List<Post>>> get();
  Future<Either<Failure, List<Post>>> getThis(int id);
  Future<Either<Failure, Post>> add(CreatePostForm form);
  Future<Either<Failure, Post>> update(int id, UpdatePostForm form);
  Future<Either<Failure, void>> delete(int id);
}

abstract class CommentRepository extends Repository {
  Future<Either<Failure, List<Comment>>> get(int postId);
  Future<Either<Failure, List<Comment>>> getThis(int id);
  Future<Either<Failure, Comment>> add(CreateCommentForm form);
  Future<Either<Failure, Comment>> update(int id, UpdateCommentForm form);
  Future<Either<Failure, void>> delete(int id);
}
