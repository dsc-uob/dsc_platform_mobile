import 'package:dio/dio.dart';

import '../utils/authentication_manager.dart';
import '../utils/cache_manager.dart';

abstract class DataSource {
  /// Used to check it data source initial or not.
  bool prepared;

  DataSource() {
    prepared = false;
  }

  /// For initial data source.
  Future<void> setup() async {
    prepared = true;
  }

  Future<void> dispose() async {}
}

abstract class LocalDataSource extends DataSource {
  final CacheManager cacheManager;

  LocalDataSource(this.cacheManager) {
    prepared = true;
  }

  @override
  Future<void> setup() async {
    await cacheManager.setup();
    prepared = true;
  }

  @override
  Future<void> dispose() {
    return cacheManager.dispose();
  }
}

abstract class RemoteDataSource extends DataSource {
  /// Final & public params.
  final Dio http;

  /// Final & private params.
  /// Used for authenticate requests.
  final AuthenticationManager authManager;

  RemoteDataSource(this.http, this.authManager);

  @override
  Future<void> setup() async {
    await authManager.setup();

    if (authManager.isAuthenticated)
      http.options = BaseOptions(
        headers: {
          'Authorization': 'Token ${authManager.token}',
        },
      );

    prepared = true;
  }
}
