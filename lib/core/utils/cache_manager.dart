import 'dart:convert';
import 'package:meta/meta.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bases/entities.dart';
import '../bases/manager.dart';
import '../bases/models.dart';
import '../bases/serializer.dart';
import '../constant.dart' as constant;
import '../errors/exceptions.dart';

class CacheManager extends Manager {
  final SharedPreferences _prefe;
  final FlutterSecureStorage _storage;

  CacheManager(this._prefe, this._storage);

  Future<bool> cahce(String key, Serializer serializer) async {
    if (key == null) throw NoKeyToCacheException();
    if (serializer == null) throw NoValueToCacheException();

    final strignData = jsonEncode(serializer.generateMap());

    if (strignData == null)
      throw CacheManagerException('the retrieve string data is null!');

    if (strignData.isEmpty)
      throw CacheManagerException('the retrieve string data is empty!');

    return await _prefe.setString(key, strignData);
  }

  Future<dynamic> loadCache(String key) async {
    if (key == null) throw NoKeyToCacheException();

    final stringData = await _prefe.get(key);
    return jsonDecode(stringData);
  }

  Future<void> storeToken(String token) async {
    if (token == null) throw CacheManagerException('the token is null!');

    return await _storage.write(key: constant.TOKEN_KEY, value: token);
  }

  Future<void> secureCache(String key, Serializer serializer) async {
    if (key == null) throw NoKeyToCacheException();
    if (serializer == null) throw NoValueToCacheException();
    final strignData = jsonEncode(serializer.generateMap());

    if (strignData == null)
      throw CacheManagerException('the retrieve string data is null!');

    if (strignData.isEmpty)
      throw CacheManagerException('the retrieve string data is empty!');

    return await _storage.write(key: constant.TOKEN_KEY, value: strignData);
  }

  Future<dynamic> loadSecureCache(String key) async {
    if (key == null) throw NoKeyToCacheException();

    final stringData = await _storage.read(key: key);
    return jsonDecode(stringData);
  }

  Future<User> get currentUser async {
    final userStringData = _prefe.getString(constant.CURRENT_USER_KEY);
    final token = await _storage.read(key: constant.TOKEN_KEY);

    if (userStringData == null) throw NoUserLoginException();

    final userData = jsonDecode(userStringData);
    userData[constant.TOKEN_KEY] = token;
    return UserModel.fromJson(userData);
  }

  Future<void> clean() {
    return Future.wait<void>([
      _prefe.clear(),
      _storage.deleteAll(),
    ]);
  }

  @visibleForTesting
  static void setMockInitialValues(Map<String, dynamic> values) async {
    return SharedPreferences.setMockInitialValues(values);
  }
}
