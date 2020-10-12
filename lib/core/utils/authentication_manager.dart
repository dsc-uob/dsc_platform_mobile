import '../contrib/manager.dart';
import '../constant.dart';
import 'cache_manager.dart';

class AuthenticationManager extends Manager {
  /// Final and required params.
  final CacheManager _cacheManager;

  AuthenticationManager(this._cacheManager);

  /*
   * Changable params.
   * @param token: userd to store token and chage every it change. 
  */
  static String _token;
  String get token => _token;

  /// Use for check if user login or not.
  bool get isAuthenticated => prepared && _token != null;

  @override
  Future<void> setup() async {
    if (_token != null) return;
    final token = await _cacheManager.loadSecureCache(TOKEN_KEY);

    if (token != null && token is String) {
      _token = token;
    }

    prepared = true;
  }

  Future<void> update(String token) async {
    _token = token;
    return await _cacheManager.storeToken(token);
  }

  Future<void> dispose() {
    return _cacheManager.dispose();
  }
}
