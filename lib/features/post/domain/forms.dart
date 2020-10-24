import 'package:equatable/equatable.dart';

class CreatePostForm extends Equatable {
  final String title;
  final String body;

  const CreatePostForm(this.title, this.body);

  @override
  List<Object> get props => [title, body];
}

class UpdatePostForm extends Equatable {
  final int id;
  final String title;
  final String body;

  const UpdatePostForm({
    this.id,
    this.title,
    this.body,
  });

  @override
  List<Object> get props => [id, title, body];
}

class CreateCommentForm extends Equatable {
  final int postId;
  final String body;

  const CreateCommentForm(this.postId, this.body);

  @override
  List<Object> get props => [postId, body];
}

class UpdateCommentForm extends Equatable {
  final int id;
  final int postId;
  final String body;

  const UpdateCommentForm({
    this.id,
    this.postId,
    this.body,
  });

  @override
  List<Object> get props => [id, postId, body];
}
