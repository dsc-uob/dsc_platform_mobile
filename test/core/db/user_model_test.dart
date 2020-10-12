import 'dart:convert';

import 'package:dsc_platform/core/db/models.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  UserModel user;

  setUp(() {
    user = UserModel(
      id: 3,
      username: 'Test',
      email: 'user@test.com',
      firstName: 'Test',
      isActive: true,
      isStaff: false,
      isSuperUser: false,
    );
  });

  test('Test fetch user model from map.', () {
    final userMap = jsonDecode(fixture('get_user_model.json'));

    final UserModel user2 = UserModel.fromJson(userMap);

    expect(user, user2);
  });
}
