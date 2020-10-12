import 'package:dsc_platform/core/constant.dart';
import 'package:dsc_platform/core/utils/authentication_manager.dart';
import 'package:dsc_platform/core/utils/cache_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

const TOKEN_RESPONSE = 'fo97wef5';

void main() {
  AuthenticationManager authManager;
  CacheManager cacheManager;
  MockSharedPreferences pref;
  MockFlutterSecureStorage scur;

  setUp(() {
    pref = new MockSharedPreferences();
    scur = new MockFlutterSecureStorage();
    cacheManager = new CacheManager(
      pref,
      scur,
    );
    authManager = new AuthenticationManager(cacheManager);
  });

  group('Test setup authentication manager', () {
    test('failed setup', () async {
      when(scur.read(key: TOKEN_KEY)).thenAnswer((_) async => null);
      when(cacheManager.loadSecureCache(TOKEN_KEY))
          .thenAnswer((_) async => null);

      await authManager.setup();

      expect(authManager.prepared, true);
      expect(authManager.isAuthenticated, false);
      expect(authManager.token, null);
      verify(authManager.setup());
    });

    test('success setup', () async {
      when(scur.read(key: TOKEN_KEY)).thenAnswer((_) async => TOKEN_RESPONSE);
      when(cacheManager.loadSecureCache(TOKEN_KEY))
          .thenAnswer((_) async => TOKEN_RESPONSE);

      await authManager.setup();

      expect(authManager.prepared, true);
      expect(authManager.isAuthenticated, true);
      expect(authManager.token.isEmpty, false);
      expect(authManager.token, TOKEN_RESPONSE);
    });
  });
}
