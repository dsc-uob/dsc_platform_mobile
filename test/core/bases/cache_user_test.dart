import 'package:dsc_platform/core/bases/models.dart';
import 'package:dsc_platform/core/constant.dart' as constant;
import 'package:dsc_platform/core/utils/cache_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  CacheManager manager;
  MockSecureStorage _storage;
  setUp(() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _storage = MockSecureStorage();
    manager = new CacheManager(_pref, _storage);
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test('Test cahce user.', () async {
    UserModel user = UserModel(
      id: 1,
      email: 'test@user.com',
      username: 'Test',
      firstName: 'Test',
      isActive: true,
      isStaff: false,
      isSuperUser: false,
      token: '<token here!>',
    );

    bool isCached = await manager.cahce(
      constant.CURRENT_USER_KEY,
      user,
    );

    when(_storage.write(key: constant.TOKEN_KEY, value: user.token))
        .thenAnswer((_) async => '<token here!>');

    expect(isCached, true);
  });

  test('Test reterive user from cache.', () async {
    UserModel userModel = UserModel(
      id: 1,
      email: 'test@user.com',
      username: 'Test',
      firstName: 'Test',
      isActive: true,
      isStaff: false,
      isSuperUser: false,
      token: '<token here!>',
    );

    await manager.cahce(
      constant.CURRENT_USER_KEY,
      userModel,
    );

    when(_storage.read(key: constant.TOKEN_KEY))
        .thenAnswer((_) async => Future.value('<token here!>'));

    UserModel user = await manager.currentUser;
    final token = await _storage.read(key: constant.TOKEN_KEY);
    user = user.setToken(token);

    expect(user.id, userModel.id);
    expect(user.email, userModel.email);
    expect(user.username, userModel.username);
    expect(user.firstName, userModel.firstName);
    expect(user.isActive, userModel.isActive);
    expect(user.isStaff, userModel.isStaff);
    expect(user.isSuperUser, userModel.isSuperUser);
    expect(user.token, userModel.token);
  });
}
