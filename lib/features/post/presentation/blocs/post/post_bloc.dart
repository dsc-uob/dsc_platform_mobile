import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/contrib/use_case.dart';
import '../../../../../core/errors/failure.dart';
import '../../../domain/entities.dart';
import '../../../domain/forms.dart';
import '../../../domain/usecases.dart';

part 'post_event.dart';
part 'post_state.dart';

abstract class PostBloc extends Bloc<PostsEvent, PostState> {
  final GetPosts getPosts;
  final GetUserPosts getUserPosts;
  final CreatePost createPost;
  final UpdatePost updatePost;
  final DeletePost deletePost;

  PostBloc({
    @required this.getPosts,
    @required this.getUserPosts,
    @required this.createPost,
    @required this.updatePost,
    @required this.deletePost,
  }) : super(LoadPosts());

  bool hasReachedMax = false;

  @override
  Stream<PostState> mapEventToState(
    PostsEvent event,
  ) async* {
    final currentState = state;

    if (event is RefershPosts) yield* _fetchPostsToState(refersh: true);

    if (event is FetchPosts && !hasReachedMax) yield* _fetchPostsToState();
    if (event is FetchUserPosts && !hasReachedMax)
      yield* _fetchUserPostsToState(event.user);

    if (event is CreatePostEvent && currentState is PostsSuccessfulLoaded) {
      final res = await createPost(event.form);
      yield res.fold(
        (l) => FailedCreatedPost(currentState.posts, l),
        (r) => CreatePostSuccess(
          currentState.posts..insert(0, r),
        ),
      );
    }

    if (event is UpdatePostEvent && currentState is PostsSuccessfulLoaded) {
      final res = await updatePost(event.form);
      yield res.fold(
        (l) => FailedUpdatedPost(currentState.posts, l),
        (r) => UpdatePostSuccess(
          currentState.posts
            ..removeWhere((p) => p.id == r.id)
            ..insert(0, r),
        ),
      );
    }

    if (event is DeletePostEvent && currentState is PostsSuccessfulLoaded) {
      final res = await deletePost(event.id);
      yield res.fold(
        (l) => FailedUpdatedPost(currentState.posts, l),
        (r) => DeletePostSuccess(
          currentState.posts..removeWhere((p) => p.id == event.id),
        ),
      );
    }
  }

  /// Procces of convert posts to state.
  Stream<PostState> _fetchPostsToState({bool refersh = false}) async* {
    final currentState = state;
    int offset;
    List<Post> posts = <Post>[];

    if (currentState is PostsSuccessfulLoaded && !refersh) {
      offset = currentState.posts.length;
      posts = currentState.posts;
    } else {
      offset = 0;
    }

    final res = await getPosts(
      LimitOffsetPagination(
        limit: 10,
        offset: offset,
      ),
    );

    yield res.fold(
      (l) => PostsFailedLoad(l),
      (r) {
        hasReachedMax = r.length < 10;
        return PostsSuccessfulLoaded(posts + r);
      },
    );
  }

  /// Fetch all user post.
  Stream<PostState> _fetchUserPostsToState(int user) async* {
    final currentState = state;
    int offset = 0;
    List<Post> posts = <Post>[];

    if (currentState is PostsSuccessfulLoaded) {
      offset = currentState.posts.length;
      posts = currentState.posts;
    }

    final res = await getUserPosts(
      IdLimitOffsetParams(
        id: user,
        limit: 10,
        offset: offset,
      ),
    );

    yield res.fold(
      (l) => PostsFailedLoad(l),
      (r) {
        hasReachedMax = r.length < 10;
        return PostsSuccessfulLoaded(posts + r);
      },
    );
  }
}

class GeneralPostBloc extends PostBloc {
  GeneralPostBloc({
    final GetPosts getPosts,
    final GetUserPosts getUserPosts,
    final CreatePost createPost,
    final UpdatePost updatePost,
    final DeletePost deletePost,
  }) : super(
          createPost: createPost,
          updatePost: updatePost,
          deletePost: deletePost,
          getUserPosts: getUserPosts,
          getPosts: getPosts,
        );
}

class UserPostBloc extends PostBloc {
  UserPostBloc({
    final GetPosts getPosts,
    final GetUserPosts getUserPosts,
    final CreatePost createPost,
    final UpdatePost updatePost,
    final DeletePost deletePost,
  }) : super(
          createPost: createPost,
          updatePost: updatePost,
          deletePost: deletePost,
          getUserPosts: getUserPosts,
          getPosts: getPosts,
        );
}
