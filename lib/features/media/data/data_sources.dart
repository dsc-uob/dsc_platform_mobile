import 'package:dio/dio.dart';

import '../../../core/api_routes.dart' as api;
import '../../../core/contrib/data_source.dart';
import '../../../core/contrib/use_case.dart';
import '../../../core/db/serializer.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/utils/authentication_manager.dart';
import '../../../core/utils/cache_manager.dart';
import 'models.dart';

abstract class ImageLocalDataSource extends LocalDataSource {
  ImageLocalDataSource(CacheManager cacheManager) : super(cacheManager);

  Future cache(ListSerializer images);
  Future<List<DImageModel>> getUserImage(int id);
}

const _kImage = 'IMAGES';

class ImageLocalDataSourceImpl extends ImageLocalDataSource {
  ImageLocalDataSourceImpl(CacheManager cacheManager) : super(cacheManager);

  @override
  Future<bool> cache(ListSerializer<MapSerializer> images) async {
    return await cacheManager.cahce('${_kImage}_${images.key}', images);
  }

  @override
  Future<List<DImageModel>> getUserImage(int id) async {
    try {
      final data = (await cacheManager.loadCache('${_kImage}_$id')) as List;
      return List<DImageModel>.generate(
        data.length,
        (index) => DImageModel.fromJson(data[index]),
      );
    } catch (_) {
      throw CacheManagerException('$_');
    }
  }
}

abstract class ImageRemoteDataSource extends RemoteDataSource {
  ImageRemoteDataSource(Dio http, AuthenticationManager authManager)
      : super(http, authManager);

  Future<List<DImageModel>> getUserImage(IdLimitOffsetParams params);
  Future<void> deleteImage(int id);
}

class ImageRemoteDataSourceImpl extends ImageRemoteDataSource {
  ImageRemoteDataSourceImpl(Dio http, AuthenticationManager authManager)
      : super(http, authManager);

  @override
  Future<void> deleteImage(int id) async {
    final res = await http.delete(
      api.image_url + '$id/',
    );

    if (res.statusCode != 204)
      throw UnknownException(
        code: res.statusCode,
        details: res.data,
      );
    return;
  }

  @override
  Future<List<DImageModel>> getUserImage(IdLimitOffsetParams params) async {
    final res = await http.get(
      api.image_url,
      queryParameters: {
        'user': params.id,
        if (params.limit != null && params.offset != null)
          'limit': params.limit,
        if (params.limit != null && params.offset != null)
          'offset': params.offset,
      },
    );

    if (res.statusCode != 200)
      throw UnknownException(
        code: res.statusCode,
        details: res.data,
      );

    final data = res.data['results'] as List;

    return List.generate(
      data.length,
      (index) => DImageModel.fromJson(data[index]),
    );
  }
}
