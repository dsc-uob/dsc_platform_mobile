import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/dsc_route.dart' as route;
import '../../../../core/constant.dart';
import '../../../../core/utils/strings.dart';
import '../../../../core/utils/tools.dart';
import '../blocs/authentication/authentication_bloc.dart';
import '../blocs/user/user_bloc.dart';
import '../widgets/post_card.dart';
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
      appBar: buildAppBar(),
      body: ListView.separated(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(8.0),
        itemCount: 10,
        itemBuilder: (context, index) => PostCard(),
        separatorBuilder: (_, i) => SizedBox(
          height: 5,
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(300),
      child: Container(
        height: 300,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Material(
                        color: Theme.of(context).accentColor,
                        child: IconButton(
                          icon: Icon(
                            Icons.logout,
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
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Stack(
                          children: [
                            Container(
                              height: 105,
                              width: 75,
                            ),
                            SvgPicture.asset(
                              'assets/images/profile_pic.svg',
                              height: 75,
                              width: 75,
                            ),
                            Positioned(
                              bottom: 0,
                              width: 75,
                              child: Chip(
                                label: Text(
                                  getStage(state.user.stage),
                                ),
                              ),
                            ),
                          ],
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
                              '${state.user.username} (${getGender(state.user.gender)})',
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle1,
                            ),
                            // if (false)
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
              height: 50,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }
}
