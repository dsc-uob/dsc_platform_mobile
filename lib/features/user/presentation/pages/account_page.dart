import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constant.dart';
import '../../../../core/utils/dsc_route.dart' as route;
import '../../../../core/utils/strings.dart';
import '../../../post/presentation/blocs/post/post_bloc.dart';
import '../../../post/presentation/widgets/post_card.dart';
import '../blocs/authentication/authentication_bloc.dart';
import '../blocs/user/user_bloc.dart';
import '../widgets/social_button.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    Strings.context = context;
    setStatusBarColor(StatusBarState.Opacity);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (_, b) => [
          SliverPersistentHeader(
            floating: true,
            pinned: true,
            delegate: AccountAppBarDelegate(),
          ),
        ],
        body: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostsSuccessfulLoaded) {
              if (state.posts.isEmpty)
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/annotation.svg',
                        height: 150,
                      ),
                      Text('No Posts..')
                    ],
                  ),
                );
              return ListView.separated(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.all(8.0),
                itemCount: state.posts.length,
                itemBuilder: (context, index) => PostCard(
                  post: state.posts[index],
                ),
                separatorBuilder: (_, i) => SizedBox(
                  height: 5,
                ),
              );
            }

            if (state is PostsFailedLoad) {
              return Center(
                child: Text('${state.failure}'),
              );
            }

            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class AccountAppBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double rest = 1 - (shrinkOffset / maxExtent);
    final height = 105 - ((shrinkOffset / maxExtent) * 10);
    final width = 75 - ((shrinkOffset / maxExtent) * 10);

    return Container(
      height: shrinkOffset == 0 ? maxExtent : null,
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).accentColor,
            blurRadius: 5,
          )
        ],
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(25),
        ),
      ),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is SuccessFetchAccount)
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (rest > 0.7)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Material(
                        color: Theme.of(context).accentColor,
                        child: IconButton(
                          icon: Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          tooltip: Strings.logout,
                          onPressed: () =>
                              BlocProvider.of<AuthenticationBloc>(context)
                                  .add(NowLogout()),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: OutlineButton(
                          onPressed: () => Navigator.pushNamed(
                            context,
                            route.user_form,
                            arguments: {
                              'context': context,
                              'user': state.user,
                            },
                          ),
                          child: Text(
                            Strings.edit,
                            style: Theme.of(context).primaryTextTheme.subtitle2,
                          ),
                          borderSide: BorderSide(color: Colors.white70),
                          splashColor: Colors.white54,
                          highlightedBorderColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                SafeArea(
                  top: rest < 0.7,
                  bottom: false,
                  right: false,
                  left: false,
                  maintainBottomViewPadding: true,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              Container(
                                height: height,
                                width: width,
                              ),
                              if (state.user.photo == null)
                                SvgPicture.asset(
                                  'assets/images/profile_pic.svg',
                                  height: width,
                                  width: width,
                                ),
                              if (state.user.photo != null)
                                CircleAvatar(
                                  radius: width - 33,
                                  backgroundImage: CachedNetworkImageProvider(
                                    state.user.photo,
                                  ),
                                ),
                              Positioned(
                                bottom: 0,
                                width: width,
                                child: Chip(
                                  label: Text(
                                    state.user.stringStage,
                                    style: Theme.of(context).textTheme.overline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.user.fullName,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(color: Colors.white),
                            ),
                            Text(
                              '${state.user.username} (${state.user.stringGender})',
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle1,
                            ),
                            if (rest > 0.6)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SocialIconButton(),
                                  SocialIconButton(),
                                  SocialIconButton(),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (rest > 0.7)
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          state.user.bio ?? Strings.noBio,
                          style: Theme.of(context).primaryTextTheme.subtitle2,
                        ),
                      ),
                    ],
                  ),
              ],
            );

          if (state is FieldFetchAccount)
            return Column(
              children: [
                Icon(
                  Icons.error,
                  color: Theme.of(context).errorColor,
                ),
                Text(state.failure.details),
              ],
            );

          return Container(
            width: 50,
            height: (maxExtent - shrinkOffset) > height
                ? (maxExtent - shrinkOffset)
                : height,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        },
      ),
    );
  }

  @override
  double get maxExtent => 300;

  @override
  double get minExtent => 125;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
