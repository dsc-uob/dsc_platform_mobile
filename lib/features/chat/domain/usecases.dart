import 'package:dartz/dartz.dart';

import '../../../core/contrib/use_case.dart';
import '../../../core/errors/failure.dart';
import 'entities.dart';
import 'repositories.dart';

class GetSessions extends UseCase<List<LimitChatMember>, NoParams> {
  final ChatSessionRepository repository;

  GetSessions(this.repository);

  @override
  Future<Either<Failure, List<LimitChatMember>>> call([NoParams params]) =>
      repository.fetchSessions();
}

class ListenToSessionMessages extends StreamUseCase<ChatMessage, String> {
  final InChatSessionRepository repository;

  ListenToSessionMessages(this.repository);

  @override
  Stream<ChatMessage> call(String id) => repository.joinSessionMessage(id);
}

class SendMessage extends UseCase<void, String> {
  final InChatSessionRepository repository;

  SendMessage(this.repository);

  @override
  Future<Either<Failure, void>> call(String message) =>
      Future.value(Right(repository.sendMessage(message)));
}

class GetMessages extends UseCase<List<ChatMessage>, IdLimitOffsetParams> {
  final InChatSessionRepository repository;

  GetMessages(this.repository);

  @override
  Future<Either<Failure, List<ChatMessage>>> call(IdLimitOffsetParams params) =>
      repository.fetchPastMessages(params);
}

class GetSessionData extends UseCase<ChatSession, String> {
  final ChatSessionRepository repository;

  GetSessionData(this.repository);

  @override
  Future<Either<Failure, ChatSession>> call(String params) =>
      repository.getThisSession(params);
}
