import 'package:dartz/dartz.dart';
import 'package:dsc_platform/core/contrib/use_case.dart';

import '../../../core/contrib/repository.dart';
import '../../../core/errors/failure.dart';
import 'entities.dart';

abstract class ChatSessionRepository extends Repository {
  Future<Either<Failure, List<LimitChatMember>>> fetchSessions();
  Future<Either<Failure, ChatSession>> createSession();
  Future<Either<Failure, ChatSession>> updateSession();
  Future<Either<Failure, ChatSession>> getThisSession(String id);
  Future<Either<Failure, void>> deleteSession(String id);
}

abstract class InChatSessionRepository extends Repository {
  Future<Either<Failure, List<ChatMessage>>> fetchPastMessages(IdLimitOffsetParams params);
  Stream<ChatMessage> joinSessionMessage(String id);
  Stream<ChatSession> joinSessionUpdate(String id);

  void sendMessage(String message);
}

