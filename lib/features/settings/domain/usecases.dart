import 'package:dartz/dartz.dart';

import '../../../core/contrib/use_case.dart';
import '../../../core/errors/failure.dart';
import 'entities.dart';
import 'repositories.dart';

class GetSettings extends UseCase<Settings, NoParams> {
  final SettingsRepository repository;

  GetSettings(this.repository);

  @override
  Future<Either<Failure, Settings>> call([NoParams params]) =>
      repository.fetch();
}

class SaveSettings extends UseCase<Settings, Settings> {
  final SettingsRepository repository;

  SaveSettings(this.repository);

  @override
  Future<Either<Failure, Settings>> call(Settings params) =>
      repository.saveSettings(params);
}
