import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../../../core/db/entities.dart';

class Post extends Equatable {
  final int id;
  final User user;
  final String title;
  final String body;
  final DateTime createdOn;

  const Post({
    @required this.id,
    @required this.user,
    @required this.title,
    @required this.body,
    @required this.createdOn,
  })  : assert(id != null),
        assert(user != null),
        assert(title != null),
        assert(body != null),
        assert(createdOn != null);

  @override
  List<Object> get props => [id, user, title, body, createdOn];
}

class Comment extends Equatable {
  final int id;
  final User user;
  final int postId;
  final String body;
  final DateTime createdOn;

  const Comment({
    @required this.id,
    @required this.user,
    @required this.postId,
    @required this.body,
    @required this.createdOn,
  })  : assert(id != null),
        assert(user != null),
        assert(postId != null),
        assert(body != null),
        assert(createdOn != null);

  @override
  List<Object> get props => [id, user, postId, body, createdOn];
}
