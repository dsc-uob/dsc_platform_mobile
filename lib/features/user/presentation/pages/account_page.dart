import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constant.dart';
import '../../../../core/db/entities.dart';
import '../../../../core/utils/dsc_route.dart' as route;
import '../../../../core/utils/strings.dart';
import '../../../media/presentation/widgets/images_list.dart';
import '../blocs/authentication/authentication_bloc.dart';
import '../blocs/user/user_bloc.dart';
import '../widgets/posts_list.dart';
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
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (_, b) => [
            SliverPersistentHeader(
              floating: true,
              pinned: true,
              delegate: AccountAppBarDelegate(),
            ),
          ],
          body: Column(
            children: [
              TabBar(
                indicatorColor: Theme.of(context).accentColor,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: Theme.of(context).accentColor,
                tabs: [
                  Tab(
                    text: 'Posts',
                    icon: Icon(Icons.description),
                  ),
                  Tab(
                    text: 'Images',
                    icon: Icon(Icons.image),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    PostsList(),
                    ImagesList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountAppBarDelegate extends SliverPersistentHeaderDelegate {
  bool _currentLogin(BuildContext context, User user) =>
      user.id == BlocProvider.of<AuthenticationBloc>(context).user.id;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double rest = 1 - (shrinkOffset / maxExtent);
    final height = 100 - ((shrinkOffset / maxExtent) * 10);
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
                            _currentLogin(context, state.user)
                                ? Navigator.canPop(context)
                                    ? Icons.arrow_back_ios
                                    : Icons.logout
                                : Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          tooltip: Strings.logout,
                          onPressed: () =>
                              !_currentLogin(context, state.user) ||
                                      Navigator.canPop(context)
                                  ? Navigator.pop(context)
                                  : BlocProvider.of<AuthenticationBloc>(context)
                                      .add(NowLogout()),
                        ),
                      ),
                      if (_currentLogin(context, state.user))
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
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle2,
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
                                  if (state.user.github != null)
                                    SocialIconButton(
                                      type: SocialIconButtonType.GitHub,
                                      data: state.user.github,
                                    ),
                                  if (state.user.twitter != null)
                                    SocialIconButton(
                                      type: SocialIconButtonType.Twitter,
                                      data: state.user.twitter,
                                    ),
                                  if (state.user.numberPhone != null)
                                    SocialIconButton(
                                      type: SocialIconButtonType.NumberPhone,
                                      data: state.user.numberPhone,
                                    ),
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
