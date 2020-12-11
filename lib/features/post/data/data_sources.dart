import 'package:dio/dio.dart';

import '../../../core/api_routes.dart' as api;
import '../../../core/constant.dart' as constant;
import '../../../core/contrib/data_source.dart';
import '../../../core/contrib/use_case.dart';
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

  Future<List<PostModel>> get([dynamic key]);
  Future<void> cache(ListSerializer data);
}

class PostLocalDataSourceImpl extends PostLocalDataSource {
  PostLocalDataSourceImpl(CacheManager cacheManager) : super(cacheManager);

  @override
  Future<List<PostModel>> get([dynamic key]) async {
    if (!prepared) await setup();

    final data = await cacheManager.loadCache(key ?? constant.POST_KEY);
    return List<PostModel>.generate(
      data.length,
      (index) => PostModel.fromJson(data[index]),
    );
  }

  @override
  Future<void> cache(BaseSerializer data) async {
    if (!prepared) await setup();
    return await cacheManager.cahce(constant.POST_KEY, data);
  }
}

//* Remote Data Source
abstract class PostRemoteDataSource extends RemoteDataSource {
  PostRemoteDataSource(Dio http, AuthenticationManager authManager)
      : super(http, authManager);

  Future<List<PostModel>> get(LimitOffsetPagination page);
  Future<List<PostModel>> getUserPost(IdLimitOffsetParams page);
  Future<PostModel> add(CreatePostSerializer serializer);
  Future<PostModel> update(UpdatePostSerializer serializer);
  Future<void> delete(int id);
}

class PostRemoteDataSourceImpl extends PostRemoteDataSource {
  PostRemoteDataSourceImpl(Dio http, AuthenticationManager authManager)
      : super(http, authManager);

  @override
  Future<List<PostModel>> get(LimitOffsetPagination page) async {
    if (!prepared) await setup();
    final res = await http.get(
      api.posts_url,
      queryParameters: {
        if (page.limit != null && page.offset != null) 'limit': page.limit,
        if (page.limit != null && page.offset != null) 'offset': page.offset,
      },
    );

    if (res.statusCode != 200)
      throw UnknownException(
        code: res.statusCode,
        details: '${res.data}',
      );

    final results = res.data['results'];

    return List<PostModel>.generate(
      results.length,
      (index) => PostModel.fromJson(results[index]),
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
  Future<PostModel> update(UpdatePostSerializer serializer) async {
    if (!prepared) await setup();
    final id = serializer.object.id;
    final res = await http.patch(
      api.posts_url + '$id/',
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
      api.posts_url + '$id/',
    );

    if (res.statusCode != 204)
      throw UnknownException(
        code: res.statusCode,
        details: '${res.data}',
      );
    return;
  }

  @override
  Future<List<PostModel>> getUserPost(IdLimitOffsetParams page) async {
    if (!prepared) await setup();

    final res = await http.get(
      api.posts_url,
      queryParameters: {
        'user': page.id,
        if (page.limit != null && page.offset != null) 'limit': page.limit,
        if (page.limit != null && page.offset != null) 'offset': page.offset,
      },
    );

    if (res.statusCode != 200)
      throw UnknownException(
        code: res.statusCode,
        details: '${res.data}',
      );

    final results = res.data['results'];

    return List<PostModel>.generate(
      results.length,
      (index) => PostModel.fromJson(results[index]),
    );
  }
}

//! Comment
//* Local Data Source
abstract class CommentLocalDataSource extends LocalDataSource {
  CommentLocalDataSource(CacheManager cacheManager) : super(cacheManager);

  Future<List<CommentModel>> get(int key);
  Future<void> cache(ListSerializer data);
}

class CommentLocalDataSourceImpl extends CommentLocalDataSource {
  CommentLocalDataSourceImpl(CacheManager cacheManager) : super(cacheManager);

  @override
  Future<List<CommentModel>> get(int key) async {
    if (!prepared) await setup();

    final data =
        await cacheManager.loadCache('${constant.COMMENT_KEY}_$key') as List;
    return List<CommentModel>.generate(
      data.length,
      (index) => CommentModel.fromJson(data[index]),
    );
  }

  @override
  Future<void> cache(ListSerializer data) async {
    if (!prepared) await setup();
    return await cacheManager.cahce(data.key, data);
  }
}

//* Remote Data Source
abstract class CommentRemoteDataSource extends RemoteDataSource {
  CommentRemoteDataSource(Dio http, AuthenticationManager authManager)
      : super(http, authManager);

  Future<List<CommentModel>> get(IdLimitOffsetParams page);
  Future<CommentModel> add(CreateCommentSerializer serializer);
  Future<CommentModel> update(
      int id, int postId, UpdateCommentSerializer serializer);
  Future<void> delete(int id, int postId);
}

class CommentRemoteDataSourceImpl extends CommentRemoteDataSource {
  CommentRemoteDataSourceImpl(Dio http, AuthenticationManager authManager)
      : super(http, authManager);

  @override
  Future<List<CommentModel>> get(IdLimitOffsetParams params) async {
    if (!prepared) await setup();

    final res = await http.get(
      api.comments_url,
      queryParameters: {
        'post': params.id,
        if (params.limit != null && params.offset != null)
          'limit': params.limit,
        if (params.limit != null && params.offset != null)
          'offset': params.offset,
      },
    );

    if (res.statusCode != 200)
      throw UnknownException(
        code: res.statusCode,
        details: '${res.data}',
      );

    final results = res.data['results'];

    return List<CommentModel>.generate(
      results.length,
      (index) => CommentModel.fromJson(results[index]),
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
    print(id);
    final res = await http.patch(
      api.comments_url + '$id/',
      queryParameters: {
        'post': postId,
      },
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
      api.comments_url + '$id/',
      queryParameters: {
        'post': postId,
      },
    );

    if (res.statusCode != 204)
      throw UnknownException(
        code: res.statusCode,
        details: '${res.data}',
      );
  }
}
