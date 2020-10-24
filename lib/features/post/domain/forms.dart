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
  final String body;

  const CreateCommentForm(this.body);

  @override
  List<Object> get props => [body];
}

class UpdateCommentForm extends Equatable {
  final int id;
  final String body;

  const UpdateCommentForm({
    this.id,
    this.body,
  });

  @override
  List<Object> get props => [id, body];
}
