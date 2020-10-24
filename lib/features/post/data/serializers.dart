import '../../../core/db/serializer.dart';
import '../domain/forms.dart';

class CreatePostSerializer extends Serializer<CreatePostForm> {
  const CreatePostSerializer(CreatePostForm object) : super(object);

  @override
  Map<String, dynamic> generateMap() => {
        'title': object.title,
        'body': object.body,
      };
}

class UpdatePostSerializer extends Serializer<UpdatePostForm> {
  const UpdatePostSerializer(UpdatePostForm object) : super(object);

  @override
  Map<String, dynamic> generateMap() => {
        if (object.title != null && object.title.isNotEmpty)
          'title': object.title,
        if (object.body != null && object.body.isNotEmpty) 'body': object.body,
      };
}

class CreateCommentSerializer extends Serializer<CreateCommentForm> {
  const CreateCommentSerializer(CreateCommentForm object) : super(object);

  @override
  Map<String, dynamic> generateMap() => {
        'post': object.postId,
        'body': object.body,
      };
}

class UpdateCommentSerializer extends Serializer<UpdateCommentForm> {
  const UpdateCommentSerializer(UpdateCommentForm object) : super(object);

  @override
  Map<String, dynamic> generateMap() => {
        if (object.body != null && object.body.isNotEmpty) 'body': object.body,
      };
}
