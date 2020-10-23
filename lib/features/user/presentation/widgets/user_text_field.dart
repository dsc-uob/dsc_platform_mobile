import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:meta/meta.dart';

import '../../../../core/constant.dart';

class UserTextField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType inputType;
  final TextInputAction action;
  final FocusNode focusNode;
  final VoidCallback onSubmitted;
  final bool isPassword;
  final FormFieldValidator<String> validator;
  final void Function(bool isRTL) onDirectionChange;
  final String helpText;

  const UserTextField({
    Key key,
    @required this.hintText,
    @required this.icon,
    @required this.controller,
    @required this.inputType,
    @required this.action,
    @required this.focusNode,
    this.isPassword: false,
    this.onSubmitted,
    this.validator,
    this.onDirectionChange,
    this.helpText,
  })  : assert(hintText != null),
        assert(icon != null),
        assert(focusNode != null),
        assert(controller != null),
        assert(inputType != null),
        assert(action != null),
        super(key: key);

  @override
  _UserTextFieldState createState() => _UserTextFieldState();
}

class _UserTextFieldState extends State<UserTextField> {
  bool obscureText;
  String text;

  @override
  void initState() {
    super.initState();
    obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).cardColor,
      ),
      child: TextFormField(
        textDirection: isLTR(),
        obscureText: obscureText,
        cursorRadius: Radius.circular(50),
        cursorColor: primaryColor,
        maxLines: widget.inputType == TextInputType.multiline ? 5 : 1,
        decoration: InputDecoration(
          helperText: widget.helpText,
          prefixIcon: Icon(widget.icon),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => setState(() => obscureText = !obscureText),
                )
              : null,
          hintText: widget.hintText,
        ),
        onChanged: (_) => setState(() => text = _),
        focusNode: widget.focusNode,
        controller: widget.controller,
        keyboardType: widget.isPassword && !obscureText
            ? TextInputType.visiblePassword
            : widget.inputType,
        textInputAction: widget.action,
        onFieldSubmitted: (_) => onSubmitted(),
        validator: widget.validator,
      ),
    );
  }

  void onSubmitted() => widget.action == TextInputAction.next
      ? FocusScope.of(context).requestFocus()
      : widget.onSubmitted != null
          ? widget.onSubmitted()
          : FocusScope.of(context).unfocus();

  TextDirection isLTR() {
    if (text == null) {
      final lc = Localizations.localeOf(context).languageCode;
      return lc == 'ar' ? TextDirection.rtl : TextDirection.ltr;
    }
    final detect = intl.Bidi.detectRtlDirectionality(text);

    if (!detect) return TextDirection.ltr;

    return TextDirection.rtl;
  }
}
