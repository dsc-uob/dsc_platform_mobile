import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../post/presentation/blocs/post/post_bloc.dart';
import '../../../post/presentation/widgets/post_card.dart';

class PostsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
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
    );
  }
}
