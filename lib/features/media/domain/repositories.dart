import 'package:dartz/dartz.dart';

import '../../../core/contrib/repository.dart';
import '../../../core/contrib/use_case.dart';
import '../../../core/errors/failure.dart';
import 'entities.dart';

abstract class ImageRepository extends Repository {
  Future<Either<Failure, List<DImage>>> fetchUserPost(
      IdLimitOffsetParams params);
  Future<Either<Failure, void>> delete(int id);
}
