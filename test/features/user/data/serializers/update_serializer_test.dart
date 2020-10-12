import 'package:dsc_platform/features/user/data/serializers.dart';
import 'package:dsc_platform/features/user/domain/forms.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  UpdateForm form;
  UpdateSerializer serializer;

  setUp(() {
    form = UpdateForm(
      username: 'Test',
    );
    serializer = UpdateSerializer(form);
  });

  test('Test conver to map.', () {
    /// Initial maps.
    final matcherMap = serializer.generateMap();
    final actualMap = {
      'username': 'Test',
    };

    expect(actualMap, matcherMap);
  });
}