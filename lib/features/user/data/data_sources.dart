import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../core/api_routes.dart' as api;
import '../../../core/constant.dart' as constant;
import '../../../core/contrib/data_source.dart';
import '../../../core/db/models.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/utils/authentication_manager.dart';
import '../../../core/utils/cache_manager.dart';
import 'serializers.dart';

abstract class LocalUserDataSource extends LocalDataSource {
  LocalUserDataSource(CacheManager cacheManager) : super(cacheManager);

  Future<UserModel> getCurrentUser();
  Future<void> storeUser(UserModel user);
  Future<String> get token;
  Future<void> logout();
}

class LocalUserDataSourceImpl extends LocalUserDataSource {
  LocalUserDataSourceImpl(CacheManager cacheManager) : super(cacheManager);
  @override
  Future<UserModel> getCurrentUser() async => await cacheManager.currentUser;

  @override
  Future<void> storeUser(UserModel user) async =>
      await cacheManager.cahce(constant.CURRENT_USER_KEY, user);

  @override
  Future<void> logout() async => await cacheManager.clean();

  @override
  Future<String> get token async =>
      await cacheManager.loadSecureCache(constant.TOKEN_KEY);
}

abstract class RemoteUserDataSource extends RemoteDataSource {
  RemoteUserDataSource(Dio http, AuthenticationManager authManager)
      : super(http, authManager);

  Future<UserModel> login(LoginSerializer serializer);
  Future<UserModel> register(RegisterSerializer serializer);
  Future<UserModel> me();
  Future<UserModel> update(UpdateSerializer serializer);
  Future<UserModel> getUser(int id);
}

class RemoteUserDataSourceImpl extends RemoteUserDataSource {
  RemoteUserDataSourceImpl(Dio dio, AuthenticationManager authManager)
      : super(dio, authManager);

  @override
  Future<UserModel> login(LoginSerializer serializer) async {
    final res = await http.post(
      api.login_url,
      data: serializer.generateMap(),
    );

    if (res.statusCode != 200)
      throw UnknownException(
        code: res.statusCode,
        details: jsonEncode(res.data),
      );

    authManager.update(res.data['token']);
    await setup();
    return UserModel.fromJson(res.data);
  }

  @override
  Future<UserModel> register(RegisterSerializer serializer) async {
    final res = await http.post(
      api.create_url,
      data: serializer.generateMap(),
    );

    if (res.statusCode != 201)
      throw UnknownException(
        code: res.statusCode,
        details: jsonEncode(res.data),
      );

    return UserModel.fromJson(res.data);
  }

  @override
  Future<UserModel> me() async {
    try {
      final res = await http.get(api.me_url);

      if (res.statusCode != 200)
        throw UnknownException(
          code: res.statusCode,
          details: jsonEncode(res.data),
        );
      return UserModel.fromJson(res.data);
    } catch (_) {
      if (_.response.statusCode == 401)
        throw NoUserLoginException();
      else
        throw UnknownException(
          code: _.response.statusCode,
          details: jsonEncode(_.response.data),
        );
    }
  }

  @override
  Future<UserModel> update(UpdateSerializer serializer) async {
    final res = await http.patch(
      api.me_url,
      data: serializer.generateMap(),
    );

    if (res.statusCode != 200)
      throw UnknownException(
        code: res.statusCode,
        details: jsonEncode(res.data),
      );

    return UserModel.fromJson(res.data);
  }

  @override
  Future<UserModel> getUser(int id) async {
    final res = await http.get(api.getMember(id));

    if (res.statusCode != 200)
      throw UnknownException(
        code: res.statusCode,
        details: jsonEncode(res.data),
      );

    return UserModel.fromJson(res.data);
  }
}
