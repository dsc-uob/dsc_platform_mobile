import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';
import '../domain/entities.dart';
import '../domain/repositories.dart';
import 'datasources.dart';

class SettingsRepositoryImpl extends SettingsRepository {
  final LocalSettingsDataSource localDS;

  SettingsRepositoryImpl(this.localDS);

  @override
  Future<Either<Failure, Settings>> fetch() async {
    try {
      final settings = await localDS.loadSettings();
      return Right(settings);
    } catch (_) {
      return Left(UnknownFailure('Failure with load settings!'));
    }
  }

  @override
  Future<Either<Failure, void>> saveSettings(Settings settings) async {
    try {
      final data = await localDS.saveSettings(settings);
      return Right(data);
    } catch (_) {
      return Left(UnknownFailure('Failure with save settings!'));
    }
  }
}
