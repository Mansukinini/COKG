import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {
  final String buttonText;
  final ButtonType buttonType;
  final void Function() onPressed;

  AppButton({
    @required this.buttonText,
    this.buttonType,
    this.onPressed
  });

  @override
  _AppButtonState createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}

enum ButtonType {LightBlue, Straw, Disabled, DarkGray, DarkBlue }