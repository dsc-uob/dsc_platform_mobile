import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/dsc_route.dart';
import '../../../../core/utils/get_date.dart' as date;
import '../../../../core/utils/strings.dart';
import '../../../../core/widgets/md_viewer.dart';
import '../../../user/presentation/blocs/authentication/authentication_bloc.dart';
import '../../domain/entities.dart';
import '../blocs/post/post_bloc.dart';

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
        title: BlocBuilder<PostBloc, PostState>(
          cubit: BlocProvider.of<PostBloc>(context),
          buildWhen: (c, n) {
            if (c is PostsSuccessfulLoaded &&
                n is PostsSuccessfulLoaded &&
                n is! DeletePostSuccess) {
              final cPost = c.posts.firstWhere((_) => _.id == post.id);
              final nPost = n.posts.firstWhere((_) => _.id == post.id);

              return cPost.title != nPost.title;
            }

            return c != n;
          },
          builder: (context, state) {
            Post sPost = post;

            if (state is PostsSuccessfulLoaded && state is! DeletePostSuccess)
              sPost = state.posts.firstWhere((_) => _.id == post.id);

            return Text(sPost.title);
          },
        ),
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
          if (BlocProvider.of<AuthenticationBloc>(context).user.id ==
              post.user.id)
            PopupMenuButton<int>(
              icon: Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: 1,
                  child: Text('Edit'),
                ),
                PopupMenuItem(
                  value: 0,
                  child: Text('Delete'),
                ),
              ],
              onSelected: (value) {
                if (value == 0) {
                  BlocProvider.of<PostBloc>(context).add(
                    DeletePostEvent(post.id),
                  );
                }
                if (value == 1) {
                  Navigator.pushNamed(
                    context,
                    post_edit_form,
                    arguments: {
                      'context': context,
                      'post': post,
                    },
                  );
                }
              },
            ),
        ],
      ),
      body: Column(
        children: [
          _buildHead(),
          Divider(),
          Expanded(
            child: BlocConsumer<PostBloc, PostState>(
              cubit: BlocProvider.of<PostBloc>(context),
              buildWhen: (c, n) {
                if (c is PostsSuccessfulLoaded &&
                    n is PostsSuccessfulLoaded &&
                    n is! DeletePostSuccess) {
                  final cPost = c.posts.firstWhere((_) => _.id == post.id);
                  final nPost = n.posts.firstWhere((_) => _.id == post.id);

                  return cPost == nPost;
                }

                return c == n;
              },
              listener: (context, state) {
                if (state is DeletePostSuccess) Navigator.pop(context);
              },
              builder: (context, state) {
                Post sPost = post;

                if (state is PostsSuccessfulLoaded)
                  sPost = state.posts.firstWhere((_) => _.id == post.id);

                return MDViewer(
                  data: sPost.body,
                  getDirection: () => textDirection,
                );
              },
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
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          member_account,
          arguments: widget.post.user,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.transparent,
              backgroundImage: havePhoto
                  ? CachedNetworkImageProvider(post.user.photo)
                  : null,
              child: havePhoto
                  ? null
                  : SvgPicture.asset('assets/images/profile_pic.svg'),
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
      ),
    );
  }
}
