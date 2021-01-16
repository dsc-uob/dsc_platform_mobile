import 'package:cached_network_image/cached_network_image.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/get_date.dart' as date;
import '../../../user/presentation/blocs/authentication/authentication_bloc.dart';
import '../../domain/entities.dart';

class ChatMessageCard extends StatelessWidget {
  final ChatMessage chatMessage;

  const ChatMessageCard({
    Key key,
    @required this.chatMessage,
  })  : assert(chatMessage != null),
        super(key: key);

  bool _isMyMessage(BuildContext context) =>
      BlocProvider.of<AuthenticationBloc>(context).user.id ==
      chatMessage.user.id;
  TextDirection _genTextDirection(BuildContext context) {
    final dir = Directionality.of(context);
    final isMyMessage = _isMyMessage(context);

    if (isMyMessage)
      return dir;
    else {
      if (dir == TextDirection.ltr)
        return TextDirection.rtl;
      else
        return TextDirection.ltr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final convertTD = _genTextDirection(context);
    return Directionality(
      textDirection: convertTD,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2),
        child: GestureDetector(
          onLongPressStart: (d) => _showCustomMenu(context, d),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.transparent,
                backgroundImage: chatMessage.user.photo != null
                    ? CachedNetworkImageProvider(chatMessage.user.photo)
                    : null,
                child: chatMessage.user.photo != null
                    ? null
                    : SvgPicture.asset('assets/images/profile_pic.svg'),
              ),
              SizedBox(
                width: 2.5,
              ),
              Container(
                padding: const EdgeInsets.all(5),
                constraints: BoxConstraints(
                  maxWidth: (MediaQuery.of(context).size.width / 4) * 3,
                ),
                decoration: BoxDecoration(
                  color: _isMyMessage(context)
                      ? Colors.white
                      : Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    topLeft: Radius.circular(
                        convertTD == TextDirection.ltr ? 10 : 30),
                    topRight: Radius.circular(
                        convertTD == TextDirection.rtl ? 10 : 30),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        date.parse(
                          chatMessage.createdOn,
                        ),
                        style: Theme.of(context).textTheme.caption.copyWith(
                            color:
                                _isMyMessage(context) ? null : Colors.white54),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 8,
                      ),
                      child: Text(
                        chatMessage.body,
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                            color: _isMyMessage(context) ? null : Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showCustomMenu(
      BuildContext context, LongPressStartDetails details) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    final res = await showMenu(
      elevation: 15,
      context: context,
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      items: <PopupMenuEntry<int>>[
        PopupMenuItem(
          child: Text('Edit'),
          value: 0,
        ),
        PopupMenuItem(
          child: Text('Copy'),
          value: 1,
        ),
        PopupMenuItem(
          child: Text('Reply'),
          value: 2,
        ),
        PopupMenuItem(
          child: Text('Delete'),
          value: 3,
        ),
      ],
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        overlay.size.width - details.globalPosition.dx,
        overlay.size.height - details.globalPosition.dy,
      ),
    );

    switch (res) {
      case 0:
        print("Edit");
        
        break;
      case 1:
        Clipboard.setData(new ClipboardData(text: chatMessage.body));
        Flushbar(
          flushbarPosition: FlushbarPosition.BOTTOM,
          message: 'Text Copied!',
          duration: Duration(seconds: 2),
        ).show(context);
        break;
      default:
    }
  }
}
