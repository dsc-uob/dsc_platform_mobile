import 'package:dsc_platform/features/user/data/serializers.dart';
import 'package:dsc_platform/features/user/domain/forms.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  LoginForm form;
  LoginSerializer serializer;

  setUp(() {
    form = LoginForm('Test', 'test1234');
    serializer = LoginSerializer(form);
  });

  test('Test conver to map.', () {
    /// Initial maps.
    final matcherMap = serializer.generateMap();
    final actualMap = {
      'username': 'Test',
      'password': 'test1234',
    };

    expect(actualMap, matcherMap);
  });
}
