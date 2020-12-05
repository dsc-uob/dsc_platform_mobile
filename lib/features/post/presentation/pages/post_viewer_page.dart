import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/get_date.dart' as date;
import '../../../../core/utils/dsc_route.dart';
import '../../../../core/utils/strings.dart';
import '../../../../core/widgets/md_viewer.dart';
import '../../domain/entities.dart';

class PostViewerPage extends StatefulWidget {
  final Post post;

  const PostViewerPage({
    Key key,
    @required this.post,
  })  : assert(post != null),
        super(key: key);

  @override
  _PostViewerPageState createState() => _PostViewerPageState();
}

class _PostViewerPageState extends State<PostViewerPage> {
  TextDirection textDirection;

  Post get post => widget.post;

  @override
  void initState() {
    super.initState();
    final local = Localizations.localeOf(Strings.context);
    textDirection =
        local.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
        actions: [
          IconButton(
            icon: Icon(
              textDirection == TextDirection.ltr
                  ? Icons.format_textdirection_r_to_l_outlined
                  : Icons.format_textdirection_l_to_r_outlined,
            ),
            onPressed: () => setState(() {
              if (textDirection == TextDirection.rtl)
                textDirection = TextDirection.ltr;
              else
                textDirection = TextDirection.rtl;
            }),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHead(),
          Expanded(
            child: MDViewer(
              data: widget.post.body,
              getDirection: () => textDirection,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.comment),
        onPressed: () => Navigator.pushNamed(
          context,
          comment_page,
          arguments: widget.post.id,
        ),
      ),
    );
  }

  Widget _buildHead() {
    bool havePhoto = post.user.photo != null;
    return Container(
      height: 75,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.transparent,
            backgroundImage:
                havePhoto ? CachedNetworkImageProvider(post.user.photo) : null,
            child: havePhoto
                ? null
                : SvgPicture.asset('assets/images/profile_pic.svg'),
          ),
          SizedBox(width: 5,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  post.user.fullName,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Text(
                  date.parse(post.createdOn),
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
