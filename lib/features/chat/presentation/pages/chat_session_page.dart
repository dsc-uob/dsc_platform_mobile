import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities.dart';
import '../blocs/chat_message/chat_message_bloc.dart';
import '../widgets/chat_message_card.dart';

class ChatSessionPage extends StatefulWidget {
  final LimitChatSession limitChatSession;

  const ChatSessionPage({Key key, this.limitChatSession}) : super(key: key);

  @override
  _ChatSessionPageState createState() => _ChatSessionPageState();
}

class _ChatSessionPageState extends State<ChatSessionPage> {
  LimitChatSession get limitChatSession => widget.limitChatSession;
  TextEditingController _controller = new TextEditingController();

  final _scrollController = ScrollController();
  final _scrollThreshold = 100.0;

  ChatMessageBloc messageBloc;

  @override
  void initState() {
    super.initState();
    messageBloc = BlocProvider.of<ChatMessageBloc>(context);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    messageBloc.close();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold)
      BlocProvider.of<ChatMessageBloc>(context)
          .add(FetchChatMessages(limitChatSession.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(limitChatSession.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatMessageBloc, ChatMessageState>(
              cubit: messageBloc,
              builder: (context, state) {
                if (state is ErrorWithChat) {
                  return Center(
                    child: Text('Error: ${state.failure}'),
                  );
                }

                if (state is SuccessfulChatMessageLoaded) {
                  if (state.messages.isEmpty)
                    return Center(
                      child: Text('No Messages!'),
                    );

                  return ListView.separated(
                    reverse: true,
                    controller: _scrollController,
                    itemCount: messageBloc.hasReachedMax
                        ? state.messages.length
                        : state.messages.length + 1,
                    itemBuilder: (context, index) {
                      if (index == state.messages.length)
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        );

                      return ChatMessageCard(
                        chatMessage: state.messages[index],
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                      height: 1.5,
                    ),
                  );
                }

                if (state is ChatMessageFailedLoad) {
                  return Center(
                    child: Text('Error: ${state.failure}'),
                  );
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
          _buildComment(),
        ],
      ),
    );
  }

  Widget _buildComment() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(25),
      ),
      alignment: Alignment.center,
      child: TextField(
        minLines: 1,
        maxLines: 5,
        controller: _controller,
        scrollPhysics: BouncingScrollPhysics(),
        textInputAction: TextInputAction.newline,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(8),
          
          hintText: 'Your message...',
          suffixIcon: IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              BlocProvider.of<ChatMessageBloc>(context)
                  .add(SendMessageEvent(_controller.text.trim()));
              _controller.clear();
            },
          ),
        ),
      ),
    );
  }
}
