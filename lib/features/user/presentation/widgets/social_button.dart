import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SocialIconButton extends StatelessWidget {
  final _iconSize = 15.0;

  const SocialIconButton();

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      padding: EdgeInsets.zero,
      onPressed: () {},
      icon: SvgPicture.asset(
        'assets/images/github.svg',
        width: _iconSize,
        height: _iconSize,
        color: Colors.white,
      ),
      label: Text(
        'Github',
        style:
            Theme.of(context).textTheme.caption.copyWith(color: Colors.white38),
      ),
    );
  }
}
