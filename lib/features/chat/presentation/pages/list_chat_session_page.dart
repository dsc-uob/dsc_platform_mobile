import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/chat_session/chat_session_bloc.dart';
import '../widgets/chat_session_card.dart';

class ListChatSessionPage extends StatefulWidget {
  @override
  _ListChatSessionPageState createState() => _ListChatSessionPageState();
}

class _ListChatSessionPageState extends State<ListChatSessionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<ChatSessionBloc>(context).add(FetchChatSession());
          await Future.delayed(Duration(seconds: 2));
        },
        child: BlocBuilder<ChatSessionBloc, ChatSessionState>(
          builder: (context, state) {
            if (state is ChatSessionsSuccessfulLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.all(5),
                itemCount: state.sessions.length,
                itemBuilder: (context, index) => ChatSessionCard(
                  chatMember: state.sessions[0],
                ),
              );
            }

            if (state is FailedChatSession) {
              return Center(
                child: Text(state.failure.details),
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
