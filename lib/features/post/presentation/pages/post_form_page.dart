import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_widget/markdown_widget.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/strings.dart';
import '../../../../core/widgets/md_editor.dart';
import '../../../../core/widgets/md_viewer.dart';
import '../../domain/entities.dart';
import '../../domain/forms.dart';
import '../blocs/post/post_bloc.dart';

class PostFormPage extends StatefulWidget {
  final bool isEdit;
  final Post post;

  const PostFormPage({
    Key key,
    this.isEdit: false,
    this.post,
  }) : super(key: key);

  @override
  _PostFormPageState createState() => _PostFormPageState();
}

class _PostFormPageState extends State<PostFormPage> {
  TextEditingController _controller;
  TocController _tocController;

  TextDirection _textDirection;

  bool get isEdit => widget.isEdit;
  Post get post => widget.post;

  void initState() {
    super.initState();
    if (isEdit && post == null) throw NoPostOnEditModeException();

    _controller = TextEditingController(
      text: isEdit ? post.body : null,
    );
    _tocController = TocController();
    _textDirection = TextDirection.ltr;

    _controller.addListener(listener);
  }

  @override
  void dispose() {
    _controller.removeListener(listener);
    _controller.dispose();
    super.dispose();
  }

  void listener() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(Strings.post),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                _textDirection == TextDirection.rtl
                    ? Icons.format_textdirection_r_to_l
                    : Icons.format_textdirection_l_to_r,
              ),
              tooltip: Strings.changeTextDirection,
              onPressed: () {
                setState(() {
                  if (_textDirection == TextDirection.rtl)
                    _textDirection = TextDirection.ltr;
                  else
                    _textDirection = TextDirection.rtl;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.save),
              tooltip: Strings.save,
              onPressed: () async {
                final controller = new TextEditingController(
                  text: isEdit ? post.title : null,
                );
                final title = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('العنوان'),
                    content: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: 'أُكتب عنواناً للمنشور هنا!',
                      ),
                    ),
                    actions: [
                      FlatButton(
                        child: Text(Strings.cancel),
                        onPressed: () => Navigator.pop(context),
                      ),
                      FlatButton(
                        child: Text(Strings.done),
                        onPressed: () =>
                            Navigator.pop(context, controller.text.trim()),
                      ),
                    ],
                  ),
                );

                if (title != null) {
                  if (isEdit) {
                    BlocProvider.of<PostBloc>(context).add(
                      UpdatePostEvent(UpdatePostForm(
                        id: post.id,
                        title: title,
                        body: _controller.text.trim(),
                      )),
                    );
                  } else {
                    BlocProvider.of<PostBloc>(context).add(
                      CreatePostEvent(CreatePostForm(
                        title,
                        _controller.text.trim(),
                      )),
                    );
                  }
                  Navigator.pop(context);
                }
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Editor',
              ),
              Tab(
                text: 'Viewer',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MDEditor(
              getDirection: () => _textDirection,
              controller: _controller,
            ),
            MDViewer(
              data: _controller.text,
              controller: _tocController,
              getDirection: () => _textDirection,
            ),
          ],
        ),
      ),
    );
  }
}
