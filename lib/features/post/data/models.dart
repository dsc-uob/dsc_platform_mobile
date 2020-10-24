import 'package:meta/meta.dart';

import '../../../core/db/models.dart';
import '../../../core/db/serializer.dart';
import '../domain/entities.dart';

class PostModel extends Post implements Serializer {
  @override
  final UserModel user;

  const PostModel({
    @required int id,
    @required this.user,
    @required String title,
    @required String body,
    @required DateTime createdOn,
  }) : super(
          id: id,
          user: user,
          title: title,
          body: body,
          createdOn: createdOn,
        );

  factory PostModel.fromJson(Map<String, dynamic> data) => PostModel(
        id: data['id'],
        user: UserModel.fromJson(data['user']),
        title: data['title'],
        body: data['body'],
        createdOn: DateTime.parse(data['created_on']),
      );

  PostModel copyWith({
    int id,
    UserModel user,
    String title,
    String body,
    DateTime createdOn,
  }) =>
      PostModel(
        id: id ?? this.id,
        user: user ?? this.user,
        title: title ?? this.title,
        body: body ?? this.body,
        createdOn: createdOn ?? this.createdOn,
      );

  @override
  Map<String, dynamic> generateMap() => {
        'id': id,
        'user': user.generateMap(),
        'title': title,
        'body': body,
        'created_on': createdOn,
      };

  @override
  get object => this;
}

class CommentModel extends Comment implements Serializer {
  @override
  final UserModel user;

  const CommentModel({
    @required int id,
    @required this.user,
    @required int postId,
    @required String body,
    @required DateTime createdOn,
  }) : super(
          id: id,
          user: user,
          postId: postId,
          body: body,
          createdOn: createdOn,
        );

  factory CommentModel.fromJson(Map<String, dynamic> data) => CommentModel(
        id: data['id'],
        postId: data['post'],
        body: data['body'],
        user: UserModel.fromJson(data['user']),
        createdOn: DateTime.parse(data['created_on']),
      );

  CommentModel copyWith({
    int id,
    int postId,
    UserModel user,
    String body,
    DateTime createdOn,
  }) =>
      CommentModel(
        id: id ?? this.id,
        postId: postId ?? this.postId,
        body: body ?? this.body,
        user: user ?? this.user,
        createdOn: createdOn ?? this.createdOn,
      );

  @override
  Map<String, dynamic> generateMap() => {
        'id': id,
        'user': user.generateMap(),
        'body': body,
        'post': postId,
        'created_on': createdOn.toString(),
      };

  @override
  get object => this;
}
