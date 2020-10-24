import 'package:dio/dio.dart';

import '../../../core/api_routes.dart' as api;
import '../../../core/constant.dart' as constant;
import '../../../core/contrib/data_source.dart';
import '../../../core/db/serializer.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/utils/authentication_manager.dart';
import '../../../core/utils/cache_manager.dart';
import 'models.dart';
import 'serializers.dart';

//! Post
//* Local Data Source
abstract class PostLocalDataSource extends LocalDataSource {
  PostLocalDataSource(CacheManager cacheManager) : super(cacheManager);

  Future<List<PostModel>> get();
  Future<void> cache(Serializer data);
}

class PostLocalDataSourceImpl extends PostLocalDataSource {
  PostLocalDataSourceImpl(CacheManager cacheManager) : super(cacheManager);

  @override
  Future<List<PostModel>> get() async {
    if (!prepared) await setup();

    final data = await cacheManager.loadCache(constant.POST_KEY) as List;
    return List<PostModel>.generate(
      data.length,
      (index) => PostModel.fromJson(data[index]),
    );
  }

  @override
  Future<void> cache(Serializer data) async {
    if (!prepared) await setup();
    return await cacheManager.cahce(constant.POST_KEY, data);
  }
}

//* Remote Data Source
abstract class PostRemoteDataSource extends RemoteDataSource {
  PostRemoteDataSource(Dio http, AuthenticationManager authManager)
      : super(http, authManager);

  Future<List<PostModel>> get();
  Future<PostModel> add(CreatePostSerializer serializer);
  Future<PostModel> update(int id, UpdatePostSerializer serializer);
  Future<void> delete(int id);
}

class PostRemoteDataSourceImpl extends PostRemoteDataSource {
  PostRemoteDataSourceImpl(Dio http, AuthenticationManager authManager)
      : super(http, authManager);

  @override
  Future<List<PostModel>> get() async {
    if (!prepared) await setup();

    final res = await http.get(
      api.posts_url,
    );

    if (res.statusCode != 200)
      throw UnknownException(
        code: res.statusCode,
        details: '${res.data}',
      );

    return List<PostModel>.generate(
      res.data.length,
      (index) => PostModel.fromJson(res.data[index]),
    );
  }

  @override
  Future<PostModel> add(CreatePostSerializer serializer) async {
    if (!prepared) await setup();

    final res = await http.post(
      api.posts_url,
      data: serializer.generateMap(),
    );

    if (res.statusCode != 201)
      throw UnknownException(
        code: res.statusCode,
        details: '${res.data}',
      );

    return PostModel.fromJson(res.data);
  }

  @override
  Future<PostModel> update(int id, UpdatePostSerializer serializer) async {
    if (!prepared) await setup();

    final res = await http.patch(
      api.thisPost(id),
      data: serializer.generateMap(),
    );

    if (res.statusCode != 200)
      throw UnknownException(
        code: res.statusCode,
        details: '${res.data}',
      );

    return PostModel.fromJson(res.data);
  }

  @override
  Future<void> delete(int id) async {
    if (!prepared) await setup();

    final res = await http.delete(
      api.thisPost(id),
    );

    if (res.statusCode != 200)
      throw UnknownException(
        code: res.statusCode,
        details: '${res.data}',
      );
  }
}

//! Comment
//* Local Data Source
abstract class CommentLocalDataSource extends LocalDataSource {
  CommentLocalDataSource(CacheManager cacheManager) : super(cacheManager);

  Future<List<CommentModel>> get();
  Future<void> cache(Serializer data);
}

class CommentLocalDataSourceImpl extends CommentLocalDataSource {
  CommentLocalDataSourceImpl(CacheManager cacheManager) : super(cacheManager);

  @override
  Future<List<CommentModel>> get() async {
    if (!prepared) await setup();

    final data = await cacheManager.loadCache(constant.COMMENT_KEY) as List;
    return List<CommentModel>.generate(
      data.length,
      (index) => CommentModel.fromJson(data[index]),
    );
  }

  @override
  Future<void> cache(Serializer data) async {
    if (!prepared) await setup();
    return await cacheManager.cahce(constant.COMMENT_KEY, data);
  }
}

//* Remote Data Source
abstract class CommentRemoteDataSource extends RemoteDataSource {
  CommentRemoteDataSource(Dio http, AuthenticationManager authManager)
      : super(http, authManager);

  Future<List<CommentModel>> get(int postId);
  Future<CommentModel> add(CreateCommentSerializer serializer);
  Future<CommentModel> update(
      int id, int postId, UpdateCommentSerializer serializer);
  Future<void> delete(int id, int postId);
}

class CommentRemoteDataSourceImpl extends CommentRemoteDataSource {
  CommentRemoteDataSourceImpl(Dio http, AuthenticationManager authManager)
      : super(http, authManager);

  @override
  Future<List<CommentModel>> get(int postId) async {
    if (!prepared) await setup();

    final res = await http.get(
      api.commentsUrl(postId),
    );

    if (res.statusCode != 200)
      throw UnknownException(
        code: res.statusCode,
        details: '${res.data}',
      );

    return List<CommentModel>.generate(
      res.data.length,
      (index) => CommentModel.fromJson(res.data[index]),
    );
  }

  @override
  Future<CommentModel> add(CreateCommentSerializer serializer) async {
    if (!prepared) await setup();

    final res = await http.post(
      api.comments_url,
      data: serializer.generateMap(),
    );

    if (res.statusCode != 201)
      throw UnknownException(
        code: res.statusCode,
        details: '${res.data}',
      );

    return CommentModel.fromJson(res.data);
  }

  @override
  Future<CommentModel> update(
      int id, int postId, UpdateCommentSerializer serializer) async {
    if (!prepared) await setup();

    final res = await http.patch(
      api.thisComment(id, postId),
      data: serializer.generateMap(),
    );

    if (res.statusCode != 200)
      throw UnknownException(
        code: res.statusCode,
        details: '${res.data}',
      );

    return CommentModel.fromJson(res.data);
  }

  @override
  Future<void> delete(int id, int postId) async {
    if (!prepared) await setup();

    final res = await http.delete(
      api.thisComment(id, postId),
    );

    if (res.statusCode != 200)
      throw UnknownException(
        code: res.statusCode,
        details: '${res.data}',
      );
  }
}
