import 'package:meta/meta.dart';

import '../../../core/db/serializer.dart';
import '../domain/entities.dart';

class SettingsModel extends Settings implements MapSerializer {
  const SettingsModel({
    @required String langCode,
    @required String fontFamily,
  }) : super(
          langCode: langCode,
          fontFamily: fontFamily,
        );

  factory SettingsModel.fromJson(Map<String, dynamic> data) => SettingsModel(
        langCode: data['langCode'],
        fontFamily: data['fontFamily'],
      );

  @override
  Map<String, dynamic> generateMap() => {
        'langCode': langCode,
        'fontFamily': fontFamily,
      };

  @override
  get object => this;
}
