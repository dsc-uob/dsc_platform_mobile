import 'package:dartz/dartz.dart';

import '../../../core/contrib/use_case.dart';
import '../../../core/errors/failure.dart';
import 'entities.dart';
import 'forms.dart';
import 'repositories.dart';

class GetPosts extends UseCase<List<Post>, LimitOffsetPagination> {
  final PostRepository repository;

  GetPosts(this.repository);

  @override
  Future<Either<Failure, List<Post>>> call(params) => repository.get(params);
}

class GetUserPosts extends UseCase<List<Post>, IdLimitOffsetParams> {
  final PostRepository repository;

  GetUserPosts(this.repository);

  @override
  Future<Either<Failure, List<Post>>> call(IdLimitOffsetParams params) =>
      repository.getUserPost(params);
}

class CreatePost extends UseCase<Post, CreatePostForm> {
  final PostRepository repository;

  CreatePost(this.repository);

  @override
  Future<Either<Failure, Post>> call(params) => repository.add(params);
}

class UpdatePost extends UseCase<Post, UpdatePostForm> {
  final PostRepository repository;

  UpdatePost(this.repository);

  @override
  Future<Either<Failure, Post>> call(params) => repository.update(params);
}

class DeletePost extends UseCase<void, int> {
  final PostRepository repository;

  DeletePost(this.repository);

  @override
  Future<Either<Failure, void>> call(params) => repository.delete(params);
}

class GetComments extends UseCase<List<Comment>, IdLimitOffsetParams> {
  final CommentRepository repository;

  GetComments(this.repository);

  @override
  Future<Either<Failure, List<Comment>>> call(params) => repository.get(params);
}

class CreateComment extends UseCase<Comment, CreateCommentForm> {
  final CommentRepository repository;

  CreateComment(this.repository);

  @override
  Future<Either<Failure, Comment>> call(params) => repository.add(params);
}

class UpdateComment extends UseCase<Comment, UpdateCommentForm> {
  final CommentRepository repository;

  UpdateComment(this.repository);

  @override
  Future<Either<Failure, Comment>> call(params) =>
      repository.update(params.id, params.postId, params);
}

class DeleteComment extends UseCase<void, Map<String, int>> {
  final CommentRepository repository;

  DeleteComment(this.repository);

  @override
  Future<Either<Failure, void>> call(params) => repository.delete(
        params['id'],
        params['postId'],
      );
}
