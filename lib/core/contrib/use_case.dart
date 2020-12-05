import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../errors/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
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

class CommentsFetchParams extends LimitOffsetPagination {
  final int post;

  const CommentsFetchParams({
    this.post,
    int limit,
    int offset,
  }) : super(
          limit: limit,
          offset: offset,
        );

  @override
  List<Object> get props => super.props..add(post);
}

class UserPostsParams extends LimitOffsetPagination {
  final int user;

  const UserPostsParams({
    this.user,
    int limit,
    int offset,
  }) : super(
          limit: limit,
          offset: offset,
        );

  @override
  List<Object> get props => super.props..add(user);
}
