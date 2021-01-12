import 'package:cokg/src/styles/textfields.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final String hintText;
  final IconData materialIcon;
  final TextInputType textInputType;
  final String errorText;
  final String initialText;
  final void Function(String) onChanged;

  AppTextField({
    @required this.hintText,
    this.materialIcon,
    this.textInputType,
    this.initialText,
    this.onChanged,
    this.errorText
  });

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        keyboardType: widget.textInputType,
        onChanged: widget.onChanged,
        decoration: TextFieldStyles.materialDecoration(widget.hintText, widget.materialIcon, widget.errorText),
        style: TextFieldStyles.text,
      ),
    );
  }
}