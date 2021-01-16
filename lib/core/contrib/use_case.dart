import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../errors/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class StreamUseCase<Type, Params> {
  Stream<Type> call(Params params);
}

class NoParams {}

abstract class Pagination extends Equatable {
  const Pagination();
}

class LimitOffsetPagination extends Pagination {
  final int limit;
  final int offset;

  const LimitOffsetPagination({
    @required this.limit,
    @required this.offset,
  })  : assert(limit != null),
        assert(offset != null);

  @override
  List<Object> get props => [limit, offset];
}

class IdLimitOffsetParams extends LimitOffsetPagination {
  final dynamic id;

  const IdLimitOffsetParams({
    this.id,
    int limit,
    int offset,
  }) : super(
          limit: limit,
          offset: offset,
        );

  @override
  List<Object> get props => super.props..add(id);
}
