import 'package:dsc_platform/core/db/serializer.dart';
import 'package:dsc_platform/core/utils/cache_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

const DATA_KEY = 'DATA_KEY';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

class SimpleSerializer extends Serializer<String> {
  SimpleSerializer(object) : super(object);

  @override
  Map<String, dynamic> generateMap() => {'data': object};
}

void main() {
  CacheManager manager;
  MockSecureStorage _storage;

  setUp(() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _storage = MockSecureStorage();
    manager = new CacheManager(_pref, _storage);
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Test caching and reteriving data.', () {
    /// Test caching using [SharedPreferences] with [cache] method.
    test('Test cahce with SharedPreferences.', () async {
      /// Initial serializer.
      final data = SimpleSerializer('This is simple data for testing cache.');

      /// Cache data and retirive if it success caching.
      bool isCached = await manager.cahce(
        DATA_KEY,
        data,
      );

      /// Check if caching successful!
      expect(isCached, true);
    });

    /// Test reteriving data from shared preferance cache.
    test('Test reterive data from shared preference cache.', () async {
      /// Initial serializer.
      final data = SimpleSerializer('This is simple data for testing cache.');

      /// Cache data.
      await manager.cahce(
        DATA_KEY,
        data,
      );

      /// Load from cache
      final loadData = await manager.loadCache(DATA_KEY);

      /// Check if equals.
      expect(data.generateMap(), loadData);
    });

    /// Test caching using [FlutterSecureStorage] with [secureCache] method.
    test('Test cahce and reterive with FlutterSecureStorage.', () async {
      /// Initial serializer.
      final matcherData =
          SimpleSerializer('This is simple data for testing cache.');

      /// Set mockito answer.
      when(_storage.read(key: DATA_KEY))
          .thenAnswer((_) async => Future.value(matcherData.object));

      /// Load from secure cache.
      final actualData = await manager.loadSecureCache(DATA_KEY);

      /// Check if equals.
      expect(actualData, matcherData.object);
    });
  });

  group('Test cache exceptions.', () {
    /// Test no key providing with [SharedPreferences] cache.
    test('Test no key providing with cache.', () async {
      /// Initial serializer.
      final data = SimpleSerializer('This is simple data for testing cache.');

      /// Check if throw execption successful!
      expect(manager.cahce(null, data), throwsException);
    });

    /// Test no data providing with [SharedPreferences] cache.
    test('Test no data providing with cache.', () async {
      /// Check if throw execption successful!
      expect(manager.secureCache(DATA_KEY, null), throwsException);
    });

    /// Test no key providing with [FlutterSecureStorage] secureCache.
    test('Test no key providing with secure cache.', () async {
      /// Initial serializer.
      final data = SimpleSerializer('This is simple data for testing cache.');

      /// Check if throw execption successful!
      expect(manager.secureCache(null, data), throwsException);
    });

    /// Test no data providing with [FlutterSecureStorage] secureCache.
    test('Test no data providing with secure cache.', () async {
      /// Check if throw execption successful!
      expect(manager.secureCache(DATA_KEY, null), throwsException);
    });
  });
}
