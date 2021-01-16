part of 'post_bloc.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object> get props => [];
}

class FetchPosts extends PostsEvent {}

class RefershPosts extends PostsEvent{}

class FetchUserPosts extends PostsEvent {
  final int user;

  const FetchUserPosts(this.user);

  @override
  List<Object> get props => [user];
}

class CreatePostEvent extends PostsEvent {
  final CreatePostForm form;

  const CreatePostEvent(this.form);

  @override
  List<Object> get props => [form];
}

class UpdatePostEvent extends PostsEvent {
  final UpdatePostForm form;

  const UpdatePostEvent(this.form);

  @override
  List<Object> get props => [form];
}

class DeletePostEvent extends PostsEvent {
  final int id;

  const DeletePostEvent(this.id);

  @override
  List<Object> get props => [id];
}
