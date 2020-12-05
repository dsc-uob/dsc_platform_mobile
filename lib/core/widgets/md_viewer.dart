import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'md_editor.dart';

class MDViewer extends StatelessWidget {
  final String data;
  final TocController controller;
  final GetDirection getDirection;
  final Map<String, dynamic> markdownTheme;

  const MDViewer({
    Key key,
    @required this.data,
    this.controller,
    this.getDirection,
    this.markdownTheme = MarkdownTheme.lightTheme,
  })  : assert(data != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    TocListWidget(controller: controller);
    return Directionality(
      textDirection:
          getDirection != null ? getDirection() : Directionality.of(context),
      child: MarkdownWidget(
        data: data,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        controller: controller,
        physics: BouncingScrollPhysics(),
        styleConfig: StyleConfig(
          markdownTheme: markdownTheme,
          pConfig: PConfig(
            onLinkTap: _launchUrl,
          ),
        ),
      ),
    );
  }

  void _launchUrl(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
