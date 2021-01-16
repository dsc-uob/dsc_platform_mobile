import 'package:dartz/dartz.dart';

import '../../../core/contrib/use_case.dart';
import '../../../core/errors/failure.dart';
import '../../../core/utils/network_info.dart';
import '../domain/entities.dart';
import '../domain/repositories.dart';
import 'datasources.dart';

class ChatSessionRepositoryImpl extends ChatSessionRepository {
  final NetworkInfoImpl networkInfo;
  final RemoteChatSessionDataSourceImpl remoteDataSource;

  ChatSessionRepositoryImpl({
    this.networkInfo,
    this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<LimitChatMember>>> fetchSessions() async {
    if (await networkInfo.isConnected) {
      try {
        final data = await remoteDataSource.fetchSessions();
        return Right(data);
      } catch (_) {
        return Left(UnknownFailure('$_'));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, ChatSession>> createSession() {}

  @override
  Future<Either<Failure, void>> deleteSession(String id) {}

  @override
  Future<Either<Failure, ChatSession>> updateSession() {}

  @override
  Future<Either<Failure, ChatSession>> getThisSession(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final res = await remoteDataSource.getThisSession(id);
        return Right(res);
      } catch (_) {
        return Left(UnknownFailure('$_'));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }
}

class InChatSessionRepositoryImpl extends InChatSessionRepository {
  final NetworkInfoImpl networkInfo;
  final RemoteInChatSessionDataSourceImpl remoteDataSource;

  InChatSessionRepositoryImpl({
    this.networkInfo,
    this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<ChatMessage>>> fetchPastMessages(
      IdLimitOffsetParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final data = await remoteDataSource.fetchPastMessages(params);
        return Right(data);
      } catch (_) {
        return Left(UnknownFailure('$_'));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Stream<ChatMessage> joinSessionMessage(String id) {
    return remoteDataSource.joinSessionMessage(id).map((event) => event);
  }

  @override
  Stream<ChatSession> joinSessionUpdate(String id) {
    return remoteDataSource.joinSessionUpdate(id).map((event) => event);
  }

  @override
  void sendMessage(String message) {
    return remoteDataSource.sendMessage(message);
  }
}
