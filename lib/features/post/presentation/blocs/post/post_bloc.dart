import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/contrib/use_case.dart';
import '../../../../../core/errors/failure.dart';
import '../../../domain/entities.dart';
import '../../../domain/forms.dart';
import '../../../domain/usecases.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostsEvent, PostState> {
  final GetPosts getPosts;
  final GetUserPosts getUserPosts;
  final CreatePost createPost;
  final UpdatePost updatePost;
  final DeletePost deletePost;

  PostBloc({
    this.getPosts,
    this.getUserPosts,
    this.createPost,
    this.updatePost,
    this.deletePost,
  }) : super(LoadPosts());

  bool _isMaxPost = false;

  @override
  Stream<PostState> mapEventToState(
    PostsEvent event,
  ) async* {
    final currentState = state;

    if (event is FetchPosts && !_isMaxPost) yield* _fetchPostsToState();
    if (event is FetchUserPosts && !_isMaxPost)
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
            ..add(r),
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
  Stream<PostState> _fetchPostsToState() async* {
    final currentState = state;
    int offset;
    List<Post> posts = <Post>[];

    if (currentState is PostsSuccessfulLoaded) {
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
        _isMaxPost = r.length == 0;
        return PostsSuccessfulLoaded(posts + r);
      },
    );
  }

  /// Fetch all user post.
  Stream<PostState> _fetchUserPostsToState(int user) async* {
    final currentState = state;
    int offset;
    List<Post> posts = <Post>[];

    if (currentState is PostsSuccessfulLoaded) {
      offset = currentState.posts.length;
      posts = currentState.posts;
    } else {
      offset = 0;
    }
    
    final res = await getUserPosts(
      UserPostsParams(
        user: user,
        limit: 10,
        offset: offset,
      ),
    );

    yield res.fold(
      (l) => PostsFailedLoad(l),
      (r) {
        _isMaxPost = r.length == 0;
        return PostsSuccessfulLoaded(posts + r);
      },
    );
  }
}
