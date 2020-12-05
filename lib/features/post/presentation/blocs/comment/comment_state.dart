part of 'comment_bloc.dart';

abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

class CommentLoad extends CommentState {}

class CommentSuccessfulLoaded extends CommentState {
  final List<Comment> comments;

  const CommentSuccessfulLoaded(this.comments);

  @override
  List<Object> get props => [...comments];
}

class ActionCommentLoad extends CommentSuccessfulLoaded {
  const ActionCommentLoad(List<Comment> comments) : super(comments);
}

class CommentFailedLoad extends CommentState {
  final Failure failure;

  const CommentFailedLoad(this.failure);

  @override
  List<Object> get props => [failure];
}

class CreateCommentSuccessful extends CommentSuccessfulLoaded {
  const CreateCommentSuccessful(List<Comment> comments) : super(comments);
}

class CreateCommentFailed extends CommentSuccessfulLoaded
    implements CommentFailedLoad {
  @override
  final Failure failure;

  const CreateCommentFailed(List<Comment> comments, this.failure)
      : super(comments);

  @override
  List<Object> get props => super.props..add(failure);
}

class DeleteCommentSuccessful extends CommentSuccessfulLoaded {
  const DeleteCommentSuccessful(List<Comment> comments) : super(comments);
}

class DeleteCommentFailed extends CommentSuccessfulLoaded
    implements CommentFailedLoad {
  @override
  final Failure failure;

  const DeleteCommentFailed(List<Comment> comments, this.failure)
      : super(comments);

  @override
  List<Object> get props => super.props..add(failure);
}

class UpdateCommentSuccessful extends CommentSuccessfulLoaded {
  const UpdateCommentSuccessful(List<Comment> comments) : super(comments);
}

class UpdateCommentFailed extends CommentSuccessfulLoaded
    implements CommentFailedLoad {
  @override
  final Failure failure;

  const UpdateCommentFailed(List<Comment> comments, this.failure)
      : super(comments);

  @override
  List<Object> get props => super.props..add(failure);
}
