import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';
import 'entities.dart';

abstract class SettingsRepository {
  Future<Either<Failure, Settings>> fetch();
  Future<Either<Failure, void>> saveSettings(Settings settings);
}
