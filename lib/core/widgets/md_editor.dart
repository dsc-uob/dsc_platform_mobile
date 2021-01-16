import 'dart:io';

import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../initial.dart';
import '../utils/cubits/uploadtask_cubit.dart';
import '../utils/strings.dart';

enum MDStyleType {
  Bold,
  Italic,
  CrossOut,
  InlineCode,

  BlockCode,
  CheckBox,
  UnCheckBox,
  Blockquotes,
  Emoji,
  GIF,

  OrderList,
  UnorderList,
  Url,
  Table,
  Image,
  Video,
}

typedef GetDirection = TextDirection Function();

class MDEditor extends StatefulWidget {
  final GetDirection getDirection;
  final TextEditingController controller;

  const MDEditor({
    Key key,
    this.getDirection,
    this.controller,
  }) : super(key: key);

  @override
  _MDEditorState createState() => _MDEditorState();
}

class _MDEditorState extends State<MDEditor> {
  TextEditingController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MDEditorHeader(
          buttons: _icons(),
          getDirection: widget.getDirection,
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Directionality(
              textDirection: widget.getDirection != null
                  ? widget.getDirection()
                  : Directionality.of(context),
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                maxLines: 100,
                decoration: InputDecoration(
                  hintText: Strings.writePostHere,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _icons() => [
        MDIconButton(
          onPressed: () => _performInline(MDStyleType.Bold),
          icon: Icon(Icons.format_bold),
          tooltip: Strings.bold,
        ),
        MDIconButton(
          onPressed: () => _performInline(MDStyleType.CrossOut),
          icon: Icon(Icons.format_clear),
          tooltip: Strings.crossOut,
        ),
        MDIconButton(
          onPressed: () => _performInline(MDStyleType.Italic),
          icon: Icon(Icons.format_italic),
          tooltip: Strings.italic,
        ),
        MDIconButton(
          onPressed: () => _performInline(MDStyleType.InlineCode),
          icon: Icon(Icons.format_shapes),
          tooltip: Strings.inlineCode,
        ),
        VerticalDivider(
          indent: 10,
          endIndent: 10,
          color: Colors.grey.shade400,
        ),
        DropdownButton<String>(
          hint: Text(
            Strings.heads,
          ),
          items: List<DropdownMenuItem<String>>.generate(
            6,
            (index) => DropdownMenuItem<String>(
              child: Text('${Strings.head} ${index + 1}'),
              value: '#' * (index + 1),
            ),
          ),
          onChanged: (value) => _addToBottom("$value Add Title Here!"),
        ),
        MDIconButton(
          onPressed: () => _performBlock(MDStyleType.Blockquotes),
          icon: Icon(Icons.format_quote),
          tooltip: Strings.quote,
        ),
        MDIconButton(
          onPressed: () => _performBlock(MDStyleType.BlockCode),
          icon: Icon(Icons.code),
          tooltip: Strings.code,
        ),
        MDIconButton(
          onPressed: () => _performBlock(MDStyleType.CheckBox),
          icon: Icon(Icons.check_box),
          tooltip: Strings.checkBox,
        ),
        MDIconButton(
          onPressed: () => _performBlock(MDStyleType.UnCheckBox),
          icon: Icon(Icons.check_box_outline_blank),
          tooltip: Strings.checkBox,
        ),
        MDIconButton(
          onPressed: () => _performBlock(MDStyleType.OrderList),
          icon: Icon(Icons.format_list_numbered),
          tooltip: Strings.listNumbered,
        ),
        MDIconButton(
          onPressed: () => _performBlock(MDStyleType.UnorderList),
          icon: Icon(Icons.format_list_bulleted),
          tooltip: Strings.listBulleted,
        ),
        VerticalDivider(
          indent: 10,
          endIndent: 10,
          color: Colors.grey.shade400,
        ),
        MDIconButton(
          onPressed: () => _performBlockDialog(MDStyleType.Emoji),
          icon: Icon(Icons.emoji_emotions),
          tooltip: Strings.emoji,
        ),
        MDIconButton(
          onPressed: () => _performBlockDialog(MDStyleType.GIF),
          icon: Icon(Icons.gif),
          tooltip: Strings.gif,
        ),
        MDIconButton(
          onPressed: () => _performBlockDialog(MDStyleType.Url),
          icon: Icon(Icons.link),
          tooltip: Strings.url,
        ),
        MDIconButton(
          onPressed: () => _performBlockDialog(MDStyleType.Table),
          icon: Icon(Icons.table_rows),
          tooltip: Strings.table,
        ),
        MDIconButton(
          onPressed: () => _performBlockDialog(MDStyleType.Image),
          icon: Icon(Icons.image),
          tooltip: Strings.image,
        ),
        MDIconButton(
          onPressed: () => _performBlockDialog(MDStyleType.Video),
          icon: Icon(Icons.video_collection),
          tooltip: Strings.video,
        ),
      ];

  void _performInline(MDStyleType type) {
    final start = controller.selection.start;
    final end = controller.selection.end;
    if (start == -1 || end == -1) return;
    String word = controller.text.substring(start, end);
    String char;
    switch (type) {
      case MDStyleType.Bold:
        char = '**';
        break;
      case MDStyleType.Italic:
        char = '*';
        break;
      case MDStyleType.CrossOut:
        char = '~~';
        break;
      case MDStyleType.InlineCode:
        char = '`';
        break;
      default:
    }
    if (start != 0 &&
        start != 1 &&
        end != controller.text.length &&
        end != controller.text.length - (char.length) &&
        controller.text.substring(start - char.length, start) == char &&
        controller.text.substring(end, end + char.length) == char) {
      controller.text =
          controller.text.replaceRange(start - char.length, start, '');
      controller.text =
          controller.text.replaceRange(end - char.length, end, '');
    } else {
      word = '$char$word$char';
      controller.text = controller.text.replaceRange(start, end, word);
    }
  }

  void _performBlock(MDStyleType type) async {
    String result;
    switch (type) {
      case MDStyleType.Blockquotes:
        result = '> This is quote';
        _addToBottom(result);
        break;

      case MDStyleType.BlockCode:
        result = "```\nWrite your code here...\n```";
        _addToBottom(result);
        break;

      case MDStyleType.CheckBox:
        result = "\n[x] This is checkbox";
        _addToBottom(result);
        break;

      case MDStyleType.UnCheckBox:
        result = "\n[ ] This is uncheckbox";
        _addToBottom(result);
        break;

      case MDStyleType.OrderList:
        result = "1. This is order list";
        _addToBottom(result);
        break;

      case MDStyleType.UnorderList:
        result = "- This is unorder list";
        _addToBottom(result);
        break;
      default:
    }
  }

  void _performBlockDialog(MDStyleType type) async {
    switch (type) {
      case MDStyleType.Emoji:
        showBottomSheet(
          context: context,
          builder: (_) => Container(
            height: 275,
            color: Theme.of(context).buttonColor.withAlpha(50),
            width: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Expanded(
                  child: EmojiPicker(
                    onEmojiSelected: (value, c) =>
                        controller.text = "${controller.text}${value.emoji}",
                  ),
                ),
              ],
            ),
          ),
        );
        return;
        break;
      case MDStyleType.GIF:
        GiphyGif gif = await GiphyGet.getGif(
          context: context,
          apiKey: "94UkCVdin1i4JT56AQXSxazaQ4vXnXwH",
        );
        if (gif != null) _addToBottom("![Image](${gif.images.original.webp})");
        break;

      case MDStyleType.Url:
        final result = await _showDialog(
          title: Strings.url,
          hintText: Strings.title,
          hintText2: Strings.url,
        );
        if (result != null) _addToBottom("[${result[0]}](${result[1]})");
        break;

      case MDStyleType.Image:
        final result = await _showImageDialog(
          title: Strings.image,
        );
        if (result != null) _addToBottom("![Image]($result)");
        break;

      default:
    }
  }

  void _addToBottom(String value) => controller.text =
      "${controller.text}${controller.text.isEmpty ? '' : '\n'}$value";

  Future<List<String>> _showDialog({
    String title,
    String hintText,
    String hintText2,
  }) async {
    final cont = TextEditingController();
    final cont2 = TextEditingController();

    return await showDialog<List<String>>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: cont,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: hintText,
              ),
            ),
            TextField(
              controller: cont2,
              maxLines: 2,
              textDirection: TextDirection.ltr,
              decoration: InputDecoration(
                hintText: hintText2,
              ),
            ),
          ],
        ),
        actions: [
          FlatButton(
            child: Text(Strings.done),
            onPressed: () => Navigator.pop(context, [
              cont.text.trim(),
              cont2.text.trim(),
            ]),
          ),
          FlatButton(
            child: Text(Strings.cancel),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Future<String> _showImageDialog({
    @required String title,
  }) async {
    assert(title != null);
    return await showDialog(
      context: context,
      builder: (context) => BlocProvider<UploadtaskCubit>(
        create: (context) => sl<UploadtaskCubit>(),
        child: AlertDialog(
          title: Text(title),
          content: BlocConsumer<UploadtaskCubit, UploadtaskState>(
            listener: (context, state) async {
              if (state is UploadtaskSuccess) {
                await Future.delayed(Duration(seconds: 2));
                Navigator.pop(context, state.url);
              }
            },
            builder: (context, state) {
              if (state is UploadtaskProgress) {
                return CircularPercentIndicator(
                  radius: 100.0,
                  lineWidth: 5,
                  percent: state.progress,
                  center:
                      new Text("${(state.progress * 100).toStringAsFixed(2)}%"),
                  progressColor: Theme.of(context).accentColor,
                );
              }

              if (state is UploadtaskSuccess) {
                return CircularPercentIndicator(
                  radius: 100.0,
                  lineWidth: 5,
                  percent: 1.0,
                  center: new Text("Successful!"),
                  progressColor: Colors.green,
                );
              }

              if (state is UploadtaskFailed) {
                return Text('${state.failure}');
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    child: Text('Gallery'),
                    onPressed: () async {
                      final image = await _getImage(ImageSource.gallery);
                      if (image != null)
                        BlocProvider.of<UploadtaskCubit>(context)
                            .uploadImage(File(image.path));
                    },
                  ),
                  RaisedButton(
                    child: Text('Camera'),
                    onPressed: () async {
                      final image = await _getImage(ImageSource.camera);
                      BlocProvider.of<UploadtaskCubit>(context)
                          .uploadImage(File(image.path));
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<File> _getImage(ImageSource source) async {
    final pickedImage = await ImagePicker().getImage(
      source: source,
      imageQuality: source == ImageSource.camera ? 75 : null,
    );

    final image = await ImageCropper.cropImage(
      sourcePath: pickedImage.path,
      aspectRatioPresets: CropAspectRatioPreset.values,
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
    );

    return image;
  }
}

class MDEditorHeader extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> buttons;
  final GetDirection getDirection;

  const MDEditorHeader({
    Key key,
    @required this.buttons,
    this.getDirection,
  })  : assert(buttons != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      constraints: BoxConstraints.tightFor(height: preferredSize.height),
      decoration: BoxDecoration(
        color: Theme.of(context).buttonColor.withAlpha(50),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        child: Row(
          textDirection: getDirection != null
              ? getDirection()
              : Directionality.of(context),
          children: List.generate(
            buttons.length,
            (index) => buttons[index],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50.0);
}

class MDIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;
  final double size;
  final Color fillColor;
  final double hoverElevation;
  final double highlightElevation;
  final String tooltip;

  const MDIconButton({
    Key key,
    this.onPressed,
    this.icon,
    this.size = 40,
    this.fillColor,
    this.hoverElevation = 1,
    this.tooltip: '',
    this.highlightElevation = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: size, height: size),
      child: Tooltip(
        message: tooltip,
        child: RawMaterialButton(
          child: icon,
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          padding: EdgeInsets.zero,
          fillColor: fillColor,
          elevation: 0,
          hoverElevation: hoverElevation,
          highlightElevation: hoverElevation,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
