part of 'chat_message_bloc.dart';

abstract class ChatMessageEvent extends Equatable {
  const ChatMessageEvent();

  @override
  List<Object> get props => [];
}

class ConnectToRoom extends ChatMessageEvent {
  final String id;

  const ConnectToRoom(this.id);

  @override
  List<Object> get props => [id];
}

class SendMessageEvent extends ChatMessageEvent {
  final String message;

  const SendMessageEvent(this.message);

  @override
  List<Object> get props => [message];
}

class ReceiveNewMessage extends ChatMessageEvent {
  final ChatMessage message;

  const ReceiveNewMessage(this.message);

  @override
  List<Object> get props => [message];
}

class FetchChatMessages extends ChatMessageEvent {
  final String id;

  const FetchChatMessages(this.id);

  @override
  List<Object> get props => [id];
}

class HandleChatMessagesError extends ChatMessageEvent {
  final dynamic failure;

  const HandleChatMessagesError(this.failure);

  @override
  List<Object> get props => [failure];
}

class DeleteMessage extends ChatMessageEvent {
  final int id;

  const DeleteMessage(this.id);

  @override
  List<Object> get props => [id];
}
