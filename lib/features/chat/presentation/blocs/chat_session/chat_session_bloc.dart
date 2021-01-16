import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../domain/entities.dart';
import '../../../domain/usecases.dart';

part 'chat_session_event.dart';
part 'chat_session_state.dart';

class ChatSessionBloc extends Bloc<ChatSessionEvent, ChatSessionState> {
  final GetSessions getSessions;

  ChatSessionBloc({
    this.getSessions,
  }) : super(ChatSessionInitial());

  @override
  Stream<ChatSessionState> mapEventToState(
    ChatSessionEvent event,
  ) async* {
    if (event is FetchChatSession) {
      final data = await getSessions();
      yield data.fold(
        (l) => FailedChatSession(l),
        (r) => ChatSessionsSuccessfulLoaded(r),
      );
    }
  }
}
