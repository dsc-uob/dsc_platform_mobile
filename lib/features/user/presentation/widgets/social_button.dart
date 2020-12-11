import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

enum SocialIconButtonType {
  GitHub,
  Twitter,
  NumberPhone,
}

class SocialIconButton extends StatelessWidget {
  final _iconSize = 15.0;
  final String data;
  final SocialIconButtonType type;

  const SocialIconButton({
    @required this.data,
    @required this.type,
  })  : assert(data != null),
        assert(type != null);

  @override
  Widget build(BuildContext context) {
    String icon;
    String title;

    switch (type) {
      case SocialIconButtonType.GitHub:
        icon = 'assets/images/github.svg';
        title = 'GitHub';
        break;
      case SocialIconButtonType.Twitter:
        icon = 'assets/images/twitter.svg';
        title = 'Twitter';
        break;
      default:
        icon = 'assets/images/whatsapp.svg';
        title = 'Whatsapp';
    }

    return FlatButton.icon(
      padding: EdgeInsets.zero,
      onPressed: () async {
        String url;
        String errorString;
        if (type == SocialIconButtonType.NumberPhone) {
          url = _whatsappUrl();
          errorString = 'You have to install whatsapp!';
        } else if (type == SocialIconButtonType.GitHub) {
          url = 'https://github.com/$data';
          errorString = 'Error with lanching github!';
        } else {
          url = 'https://twitter.com/$data';
          errorString = 'Error with lanching twitter!';
        }

        await canLaunch(url)
            ? launch(url)
            : FlushbarHelper.createError(message: errorString).show(context);
      },
      icon: SvgPicture.asset(
        icon,
        width: _iconSize,
        height: _iconSize,
        color: Colors.white,
      ),
      label: Text(
        title,
        style:
            Theme.of(context).textTheme.caption.copyWith(color: Colors.white38),
      ),
    );
  }

  String _whatsappUrl() {
    String number = data;
    if (data.startsWith('0'))
      number = data.replaceFirst(RegExp(r'0'), '+964');
    else if (!data.startsWith('+964')) number = '+964' + data;
    return "whatsapp://send?phone=$number";
  }
}
