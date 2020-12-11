import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../user/presentation/blocs/authentication/authentication_bloc.dart';
import '../../domain/entities.dart';
import '../../domain/forms.dart';
import '../blocs/comment/comment_bloc.dart';
import '../widgets/comment_card.dart';

enum CommentMode {
  New,
  Edit,
  Delete,
}

class CommentsPage extends StatefulWidget {
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  Comment comment;
  CommentMode mode;
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    mode = CommentMode.New;
    controller = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('التعليقات'),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<CommentBloc, CommentState>(
              cubit: BlocProvider.of<CommentBloc>(context),
              listener: (context, state) {
                if (state is CreateCommentSuccessful) {
                  FlushbarHelper.createSuccess(
                    title: 'تعليق جديد',
                    message: 'تم نشر التعليق بنجاح!',
                  ).show(context);
                  controller.clear();
                }

                if (state is CreateCommentFailed)
                  FlushbarHelper.createError(
                    title: 'تعليق جديد',
                    message: 'فشل نشر التعليق!',
                  ).show(context);

                if (state is UpdateCommentSuccessful) {
                  FlushbarHelper.createSuccess(
                    title: 'تعديل تعليق',
                    message: 'تم تعديل التعليق بنجاح!',
                  ).show(context);
                  controller.clear();
                  comment = null;
                  mode = CommentMode.New;
                }

                if (state is UpdateCommentFailed) {
                  FlushbarHelper.createError(
                    title: 'تعديل تعليق',
                    message: 'فشل تعديل التعليق!',
                  ).show(context);
                }

                if (state is DeleteCommentSuccessful) {
                  FlushbarHelper.createSuccess(
                    title: 'حذف تعليق',
                    message: 'تم حذف التعليق بنجاح!',
                  ).show(context);
                  controller.clear();
                  comment = null;
                  mode = CommentMode.New;
                }

                if (state is DeleteCommentFailed) {
                  FlushbarHelper.createError(
                    title: 'حذف تعليق',
                    message: 'فشل حذف التعليق!',
                  ).show(context);
                }
              },
              builder: (context, state) {
                if (state is CommentSuccessfulLoaded) {
                  if (state.comments.isEmpty) return _buildNoComment();
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) =>
                        CommentCard(
                      comment: state.comments[index],
                      onShowList: state.comments[index].user.id !=
                              BlocProvider.of<AuthenticationBloc>(context)
                                  .user
                                  .id
                          ? null
                          : (_) => _changeToOtherMode(state.comments[index], _),
                    ),
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    itemCount: state.comments.length,
                  );
                }

                if (state is CommentFailedLoad) return _buildNoComment();

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          _buildComment(),
        ],
      ),
    );
  }

  Widget _buildNoComment() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/public_discussion.svg',
          height: 300,
        ),
        Text('No Comments!'),
      ],
    );
  }

  Widget _buildComment() {
    return Container(
      color: Colors.black12,
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 10,
      ),
      child: TextField(
        minLines: 1,
        maxLines: 5,
        scrollPhysics: BouncingScrollPhysics(),
        controller: controller,
        textInputAction: TextInputAction.newline,
        decoration: InputDecoration(
          suffixIcon: BlocBuilder<CommentBloc, CommentState>(
            builder: (context, state) {
              if (state is ActionCommentLoad)
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                );

              return IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if (controller.text.isNotEmpty && mode == CommentMode.New) {
                    BlocProvider.of<CommentBloc>(context).add(
                      CreateCommentEvent(CreateCommentForm(
                        BlocProvider.of<CommentBloc>(context).post,
                        controller.text.trim(),
                      )),
                    );
                  }
                  if (controller.text.isNotEmpty && mode == CommentMode.Edit) {
                    BlocProvider.of<CommentBloc>(context).add(
                      UpdateCommentEvent(UpdateCommentForm(
                        id: comment.id,
                        postId: comment.postId,
                        body: controller.text.trim(),
                      )),
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _changeToOtherMode(
      Comment comment, LongPressStartDetails details) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        details.globalPosition,
        details.globalPosition,
      ),
      Offset.zero & overlay.size,
    );
    final cmd = await showMenu<CommentMode>(
      context: context,
      items: [
        PopupMenuItem(
          child: Text('تعديل'),
          value: CommentMode.Edit,
        ),
        PopupMenuItem(
          child: Text('حذف'),
          value: CommentMode.Delete,
        ),
      ],
      position: position,
    );

    if (cmd != null) {
      if (cmd == CommentMode.Edit) {
        setState(() {
          this.mode = cmd;
          this.comment = comment;
        });
        this.controller.text = comment.body;
      } else {
        BlocProvider.of<CommentBloc>(context).add(
          RemoveCommentEvent(
            comment.postId,
            comment.id,
          ),
        );
        FlushbarHelper.createLoading(
          message: 'جارِ حذف التعليق!',
          linearProgressIndicator: LinearProgressIndicator(),
        );
      }
    }
  }
}
