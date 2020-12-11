import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markdown_widget/markdown_widget.dart';

import '../../../../core/utils/dsc_route.dart';
import '../../../../core/utils/get_date.dart' as date;
import '../../domain/entities.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;
  final GestureLongPressStartCallback onShowList;

  const CommentCard({
    Key key,
    @required this.comment,
    this.onShowList,
  })  : assert(comment != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onLongPressStart: onShowList,
        child: Column(
          children: [
            _buildHead(context),
            Container(
              color: Theme.of(context).cardColor,
              padding: const EdgeInsets.all(2.5),
              child: MarkdownWidget(
                shrinkWrap: true,
                data: comment.body,
                physics: NeverScrollableScrollPhysics(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHead(BuildContext context) {
    return Container(
      height: 75,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          member_account,
          arguments: comment.user,
        ),
        child: Row(
          children: [
            if (comment.user.photo == null)
              SvgPicture.asset(
                'assets/images/profile_pic.svg',
                height: 60,
                width: 60,
              ),
            if (comment.user.photo != null)
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                backgroundImage: comment.user.photo == null
                    ? AssetImage('assets/images/profile_pic.svg')
                    : CachedNetworkImageProvider(comment.user.photo),
              ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    comment.user.fullName,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    date.parse(comment.createdOn),
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
