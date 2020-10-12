import '../../../core/constant.dart';
import '../../../core/contrib/data_source.dart';
import '../../../core/utils/cache_manager.dart';
import '../domain/entities.dart';
import 'models.dart';

abstract class LocalSettingsDataSource extends LocalDataSource {
  LocalSettingsDataSource(CacheManager cacheManager) : super(cacheManager);

  Future<Settings> loadSettings();
  Future<void> saveSettings(Settings settings);
}

class LocalSettingsDataSourceImpl extends LocalSettingsDataSource {
  LocalSettingsDataSourceImpl(CacheManager cacheManager) : super(cacheManager);

  @override
  Future<SettingsModel> loadSettings() async {
    final settings = await cacheManager.loadCache(SETTINGS_KEY);
    return SettingsModel.fromJson(settings);
  }

  @override
  Future<void> saveSettings(Settings settings) async {
    return await cacheManager.cahce(
      SETTINGS_KEY,
      SettingsModel(
        langCode: settings.langCode,
        fontFamily: settings.fontFamily,
      ),
    );
  }
}
