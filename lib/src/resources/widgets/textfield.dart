import 'package:cokg/src/styles/textfields.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final String hintText;
  final String labelText;
  final IconData materialIcon;
  final TextInputType textInputType;
  final String errorText;
  final String initialText;
  final bool obscureText;
  final int maxLines;
  final bool readOnly;
  final void Function(String) onChanged;

  AppTextField({
    this.hintText,
    this.labelText,
    this.materialIcon,
    this.textInputType = TextInputType.text,
    this.initialText,
    this.obscureText = false,
    this.maxLines = 1,
    this.onChanged,
    this.errorText,
    this.readOnly = false
  });

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  FocusNode _node;
  TextEditingController _controller;

  @override
  void initState() {
    _node = FocusNode();
    _controller = TextEditingController();
    if (widget.initialText != null) {
      _controller.text = widget.initialText;
    }

    // _node.addListener(_handleFocusChange);
    super.initState();
  }

  void _handleFocusChange() {
    if (_node.hasFocus == false && widget.initialText != null) {

    }
    widget.onChanged(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:12.0, left: 10.0, right: 10.0, bottom: 12.0),
      child: TextField(
        maxLines: widget.maxLines,
        keyboardType: widget.textInputType,
        onChanged: widget.onChanged,
        decoration: TextFieldStyles.materialDecoration(widget.labelText, widget.hintText, widget.materialIcon, widget.errorText),
        style: TextFieldStyles.text,
        obscureText: widget.obscureText,
        controller: _controller,
        readOnly: widget.readOnly,
      ),
    );
  }

  @override
  void dispose() {
    _node.removeListener(_handleFocusChange);
    _node.dispose();
    _controller.dispose();
    super.dispose();
  }
}