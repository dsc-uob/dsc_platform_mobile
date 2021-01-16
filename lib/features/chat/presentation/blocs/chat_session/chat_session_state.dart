part of 'chat_session_bloc.dart';

abstract class ChatSessionState extends Equatable {
  const ChatSessionState();

  @override
  List<Object> get props => [];
}

class ChatSessionInitial extends ChatSessionState {}

class LoadChatSession extends ChatSessionState {}

class ChatSessionsSuccessfulLoaded extends ChatSessionState {
  final List<LimitChatMember> sessions;

  const ChatSessionsSuccessfulLoaded(this.sessions);

  @override
  List<Object> get props => sessions;
}

class FailedChatSession extends ChatSessionState {
  final Failure failure;

  const FailedChatSession(this.failure);

  @override
  List<Object> get props => [failure];
}
