part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class LoadPosts extends PostState {}

class PostsSuccessfulLoaded extends PostState {
  final List<Post> posts;

  const PostsSuccessfulLoaded(this.posts);

  @override
  List<Object> get props => posts;
}

class PostsFailedLoad extends PostState {
  final Failure failure;

  const PostsFailedLoad(this.failure);

  @override
  List<Object> get props => [failure];
}

class CreatePostSuccess extends PostsSuccessfulLoaded {
  const CreatePostSuccess(List<Post> posts) : super(posts);
}

class FailedCreatedPost extends PostsSuccessfulLoaded
    implements PostsFailedLoad {
  @override
  final Failure failure;

  const FailedCreatedPost(List<Post> posts, this.failure) : super(posts);

  @override
  List<Object> get props => super.props..add(failure);
}

class UpdatePostSuccess extends PostsSuccessfulLoaded {
  const UpdatePostSuccess(List<Post> posts) : super(posts);
}

class FailedUpdatedPost extends PostsSuccessfulLoaded
    implements PostsFailedLoad {
  final Failure failure;

  const FailedUpdatedPost(List<Post> posts, this.failure) : super(posts);

  @override
  List<Object> get props => super.props..add(failure);
}

class DeletePostSuccess extends PostsSuccessfulLoaded {
  const DeletePostSuccess(List<Post> posts) : super(posts);
}

class FailedDeletePost extends PostState {
  final Failure failure;

  const FailedDeletePost(this.failure);

  @override
  List<Object> get props => [failure];
}
