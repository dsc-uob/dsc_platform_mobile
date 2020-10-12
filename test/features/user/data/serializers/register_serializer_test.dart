import 'package:dsc_platform/features/user/data/serializers.dart';
import 'package:dsc_platform/features/user/domain/forms.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  RegisterForm form;
  RegisterSerializer serializer;

  setUp(() {
    form = RegisterForm(
      username: 'Test',
      email: 'user@test.com',
      password: 'test1234',
      firstName: 'Test',
    );
    serializer = RegisterSerializer(form);
  });

  test('Test conver to map.', () {
    /// Initial maps.
    final matcherMap = serializer.generateMap();
    final actualMap = {
      'username': 'Test',
      'email': 'user@test.com',
      'password': 'test1234',
      'first_name': 'Test',
    };

    expect(actualMap, matcherMap);
  });
}
