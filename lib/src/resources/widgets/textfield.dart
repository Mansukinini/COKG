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
  final void Function(String) onChanged;

  AppTextField({
    this.hintText,
    this.labelText,
    this.materialIcon,
    this.textInputType = TextInputType.text,
    this.initialText,
    this.obscureText = false,
    this.onChanged,
    this.errorText
  });

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        keyboardType: widget.textInputType,
        onChanged: widget.onChanged,
        decoration: TextFieldStyles.materialDecoration(widget.labelText, widget.hintText, widget.materialIcon, widget.errorText),
        style: TextFieldStyles.text,
        obscureText: widget.obscureText,
        controller: _controller,
      ),
    );
  }
}