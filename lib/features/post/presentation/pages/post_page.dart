import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/dsc_route.dart';
import '../../../../core/utils/strings.dart';
import '../blocs/post/post_bloc.dart';
import '../widgets/post_card.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Strings.posts),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<PostBloc>(context).add(
            FetchPosts(),
          );

          return await Future.delayed(Duration(seconds: 3));
        },
        child: BlocBuilder<PostBloc, PostState>(
          cubit: BlocProvider.of<PostBloc>(context),
          builder: (context, state) {
            if (state is PostsSuccessfulLoaded) {
              return ListView.separated(
                itemBuilder: (context, index) =>
                    PostCard(post: state.posts[index]),
                separatorBuilder: (context, index) => SizedBox(
                  height: 5,
                ),
                itemCount: state.posts.length,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(
          context,
          post_form,
          arguments: context,
        ),
        tooltip: Strings.create + ' ' + Strings.post,
        child: Icon(Icons.post_add),
      ),
    );
  }
}
