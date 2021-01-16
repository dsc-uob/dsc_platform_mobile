part of 'chat_message_bloc.dart';

abstract class ChatMessageState extends Equatable {
  const ChatMessageState();

  @override
  List<Object> get props => [];
}

class ChatMessageInitial extends ChatMessageState {}

class ChatMessageLoading extends ChatMessageState {}

class SuccessfulChatMessageLoaded extends ChatMessageState {
  final List<ChatMessage> messages;

  const SuccessfulChatMessageLoaded({
    this.messages,
  });

  @override
  List<Object> get props => messages;
}

class ChatMessageFailedLoad extends ChatMessageState {
  final Failure failure;

  const ChatMessageFailedLoad(this.failure);

  @override
  List<Object> get props => [failure];
}

class ConnectedToChat extends SuccessfulChatMessageLoaded {
  @override
  final List<ChatMessage> messages;

  @override
  List<Object> get props => [...messages];

  const ConnectedToChat(
    this.messages,
  ) : super(messages: messages);
}

class NewChatMessage extends ConnectedToChat {
  @override
  final List<ChatMessage> messages;

  @override
  List<Object> get props => [DateTime.now()];

  const NewChatMessage(
    this.messages,
  ) : super(messages);
}

class ErrorWithChat extends SuccessfulChatMessageLoaded {
  final dynamic failure;

  const ErrorWithChat({
    List<ChatMessage> messages,
    this.failure,
  }) : super(
          messages: messages,
        );
}
