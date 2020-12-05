part of 'comment_bloc.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object> get props => [];
}

class FetchComments extends CommentEvent {
  final int post;

  const FetchComments(this.post);

  @override
  List<Object> get props => [post];
}

class CreateCommentEvent extends CommentEvent {
  final CreateCommentForm form;

  const CreateCommentEvent(this.form);

  @override
  List<Object> get props => [form];
}

class UpdateCommentEvent extends CommentEvent {
  final UpdateCommentForm form;

  const UpdateCommentEvent(this.form);

  @override
  List<Object> get props => [form];
}

class RemoveCommentEvent extends CommentEvent {
  final int post;
  final int comment;

  const RemoveCommentEvent(this.post, this.comment);

  @override
  List<Object> get props => [post, comment];
}
