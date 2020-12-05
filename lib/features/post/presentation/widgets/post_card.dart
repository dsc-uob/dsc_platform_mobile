import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/get_date.dart' as date;
import '../../../../core/utils/dsc_route.dart';
import '../../domain/entities.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({
    Key key,
    @required this.post,
  })  : assert(post != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 300,
        child: InkWell(
          onTap: () => Navigator.pushNamed(
            context,
            post_view,
            arguments: post,
          ),
          child: Column(
            children: [
              Expanded(
                flex: 7,
                child: Container(
                  child: SvgPicture.asset(
                    'assets/images/posts.svg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  color: Colors.white12,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2.5,
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        post.title,
                        style: Theme.of(context).textTheme.headline5,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.transparent,
                            backgroundImage: post.user.photo != null
                                ? CachedNetworkImageProvider(post.user.photo)
                                : null,
                            child: post.user.photo != null
                                ? null
                                : SvgPicture.asset(
                                    'assets/images/profile_pic.svg'),
                          ),
                          SizedBox(
                            width: 5,
                          ),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
