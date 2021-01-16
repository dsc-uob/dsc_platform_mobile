part of 'chat_session_bloc.dart';

abstract class ChatSessionEvent extends Equatable {
  const ChatSessionEvent();

  @override
  List<Object> get props => [];
}

class FetchChatSession extends ChatSessionEvent {}
