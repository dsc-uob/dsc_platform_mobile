import 'package:dartz/dartz.dart';

import '../../../core/contrib/use_case.dart';
import '../../../core/errors/failure.dart';
import 'entities.dart';
import 'repositories.dart';

class GetUserImage extends UseCase<List<DImage>, IdLimitOffsetParams> {
  final ImageRepository repository;

  GetUserImage(this.repository);

  @override
  Future<Either<Failure, List<DImage>>> call(IdLimitOffsetParams params) =>
      repository.fetchUserPost(params);
}

class DeleteUserImage extends UseCase<void, int> {
  final ImageRepository repository;

  DeleteUserImage(this.repository);

  @override
  Future<Either<Failure, void>> call(int params) => repository.delete(params);
}
