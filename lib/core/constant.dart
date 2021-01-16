import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Const Words
const CURRENT_USER_KEY = 'CURRENT_USER';
const POST_KEY = 'POSTS';
const COMMENT_KEY = 'COMMENTS';
const TOKEN_KEY = 'TOKEN';
const SETTINGS_KEY = 'SETTINGS';
const DSC_PLATFORM = 'DSC Platform';

/// Const Server Data
const server_ip = '192.46.235.59';
const server_port = 443;
const domain = 'iqds.club';
const web_url = 'https://$domain/';

/// Const colors
const Color primaryColor = const Color(0xff3F3D56);
const Color secondColor = const Color(0xfff5f7fa);
const Color cardColor = const Color(0xffE6E6E6);
const Color statusBarColor = const Color(0xff1c1c27);

enum StatusBarState {
  Default,
  Opacity,
  Fill,
}

/// Functions
void setStatusBarColor(StatusBarState state) {
  Color color;

  switch (state) {
    case StatusBarState.Fill:
      color = primaryColor;
      break;
    case StatusBarState.Opacity:
      color = statusBarColor.withOpacity(0.75);
      break;
    default:
      color = primaryColor;
  }

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: color,
    ),
  );
}
