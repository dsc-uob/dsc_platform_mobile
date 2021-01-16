import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/contrib/use_case.dart';
import '../../../../../core/errors/failure.dart';
import '../../../domain/entities.dart';
import '../../../domain/usecases.dart';

part 'chat_message_event.dart';
part 'chat_message_state.dart';

class ChatMessageBloc extends Bloc<ChatMessageEvent, ChatMessageState> {
  final SendMessage sendMessage;
  final GetMessages getMessages;
  final ListenToSessionMessages listenToSessionMessages;

  ChatMessageBloc({
    this.sendMessage,
    this.getMessages,
    this.listenToSessionMessages,
  }) : super(ChatMessageInitial());

  bool hasReachedMax = false;

  bool isOpen = false;

  StreamSubscription _chatSubscription;

  @override
  Stream<ChatMessageState> mapEventToState(
    ChatMessageEvent event,
  ) async* {
    final currentState = state;

    if (event is FetchChatMessages && !hasReachedMax) {
      int offset = 0;
      List<ChatMessage> messages = [];

      if (currentState is SuccessfulChatMessageLoaded) {
        offset = currentState.messages.length;
        messages = currentState.messages;
      }

      final params = IdLimitOffsetParams(
        id: event.id,
        limit: 25,
        offset: offset,
      );
      final res = await getMessages(params);

      yield res.fold(
        (l) => null,
        (r) {
          hasReachedMax = r.length <= 25;
          return SuccessfulChatMessageLoaded(
            messages: messages + r,
          );
        },
      );
      if (!isOpen) add(ConnectToRoom(params.id));
    }

    if (event is ConnectToRoom && currentState is SuccessfulChatMessageLoaded) {
      final stream = listenToSessionMessages(event.id);
      _chatSubscription = stream.listen(
        (event) => add(ReceiveNewMessage(event)),
        onError: (_) => add(HandleChatMessagesError(_)),
      );
      isOpen = true;
    }
    if (event is SendMessageEvent &&
        currentState is SuccessfulChatMessageLoaded) {
      sendMessage(event.message);
    }
    if (event is ReceiveNewMessage &&
        currentState is SuccessfulChatMessageLoaded) {
      currentState.messages.insert(0, event.message);

      yield NewChatMessage(
        currentState.messages,
      );
    }
    if (event is HandleChatMessagesError &&
        currentState is SuccessfulChatMessageLoaded) {
      yield ErrorWithChat(
        messages: currentState.messages,
        failure: event.failure,
      );
    }
  }

  @override
  Future<void> close() async {
    await _chatSubscription?.cancel();
    return await super.close();
  }
}
