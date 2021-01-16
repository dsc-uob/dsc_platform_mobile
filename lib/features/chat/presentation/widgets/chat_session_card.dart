import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/dsc_route.dart';
import '../../domain/entities.dart';

class ChatSessionCard extends StatelessWidget {
  final LimitChatMember chatMember;

  const ChatSessionCard({Key key, this.chatMember}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      margin: const EdgeInsets.all(2.5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListTile(
        onTap: () => Navigator.pushNamed(
          context,
          session_message_page,
          arguments: chatMember.chatSession,
        ),
        leading: SvgPicture.asset(
          'assets/images/messaging.svg',
          height: 50,
        ),
        title: Text(chatMember.chatSession.title),
        trailing: chatMember.hasRole
            ? Chip(
                label: Text(chatMember.role.title),
              )
            : null,
      ),
    );
  }
}
