import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../../core/contrib/use_case.dart';
import '../../../../../core/errors/failure.dart';
import '../../../domain/entities.dart';
import '../../../domain/forms.dart';
import '../../../domain/usecases.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final GetComments getComments;
  final CreateComment createComment;
  final UpdateComment updateComment;
  final DeleteComment deleteComment;

  int _post;
  int get post => _post;

  CommentBloc({
    @required this.getComments,
    @required this.createComment,
    @required this.updateComment,
    @required this.deleteComment,
  })  : assert(getComments != null),
        assert(createComment != null),
        assert(updateComment != null),
        assert(deleteComment != null),
        super(CommentLoad());

  bool _hasMax = false;

  @override
  Stream<CommentState> mapEventToState(
    CommentEvent event,
  ) async* {
    final currentState = state;

    if (event is FetchComments && !_hasMax) {
      _post = event.post;
      int offset;
      List<Comment> comments = <Comment>[];
      if (currentState is CommentSuccessfulLoaded) {
        offset = currentState.comments.length;
        comments = currentState.comments;
      } else {
        offset = 0;
      }

      final res = await getComments(
        CommentsFetchParams(
          limit: 10,
          offset: offset,
          post: event.post,
        ),
      );

      yield res.fold(
        (l) => CommentFailedLoad(l),
        (r) {
          _hasMax = r.length == 0;
          return CommentSuccessfulLoaded(comments + r);
        },
      );
    }

    if (event is CreateCommentEvent &&
        currentState is CommentSuccessfulLoaded) {
      yield ActionCommentLoad(currentState.comments);

      final res = await createComment(event.form);
      yield res.fold(
        (l) => CreateCommentFailed(currentState.comments, l),
        (r) => CreateCommentSuccessful(
          currentState.comments..add(r),
        ),
      );
    }

    if (event is UpdateCommentEvent &&
        currentState is CommentSuccessfulLoaded) {
      yield ActionCommentLoad(currentState.comments);

      final res = await updateComment(event.form);
      yield res.fold(
        (l) => UpdateCommentFailed(currentState.comments, l),
        (r) => UpdateCommentSuccessful(
          currentState.comments
            ..removeWhere((p) => p.id == r.id)
            ..add(r),
        ),
      );
    }

    if (event is RemoveCommentEvent &&
        currentState is CommentSuccessfulLoaded) {
      final res = await deleteComment({
        'id': event.comment,
        'postId': event.post,
      });

      yield res.fold(
        (l) => DeleteCommentFailed(currentState.comments, l),
        (r) => DeleteCommentSuccessful(
          currentState.comments..removeWhere((p) => p.id == event.comment),
        ),
      );
    }
  }
}
