import 'package:cokg/src/styles/base.dart';
import 'package:cokg/src/styles/button.dart';
import 'package:cokg/src/styles/color.dart';
import 'package:cokg/src/styles/text.dart';
import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {
  final String labelText;
  final ButtonType buttonType;
  final void Function() onPressed;

  AppButton({
    @required this.labelText,
    this.buttonType,
    this.onPressed
  });

  @override
  _AppButtonState createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    TextStyle fontStyle;
    Color buttonColor;

    switch (widget.buttonType) {
      case ButtonType.LightBlue:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.brown;
      break;
      case ButtonType.Disabled:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.lightgray;
      break;
      default:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.brown;
      break;
    }

    return AnimatedContainer(
      padding: EdgeInsets.only(
        top: (pressed) ? BaseStyles.listFieldVertical + BaseStyles.animationOffset : BaseStyles.listFieldVertical,
        left: BaseStyles.listFieldHorizontal,
        right: BaseStyles.listFieldHorizontal,
        bottom: (pressed) ? BaseStyles.listFieldVertical - BaseStyles.animationOffset : BaseStyles.listFieldVertical
      ),
      child: GestureDetector(
        child: Container(
          child: Center(child: Text(widget.labelText, style: fontStyle)),
          height: ButtonStyles.buttonHeight,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(BaseStyles.borderRadius),
            boxShadow: pressed ? BaseStyles.boxShadowPressed : BaseStyles.boxShadow
          ),
        ),
        onTapDown: (details){
          setState(() {
            if (widget.buttonType != ButtonType.Disabled)
              pressed = !pressed;
          });
        },
        onTapUp: (details){
          if (widget.buttonType != ButtonType.Disabled)
            pressed = !pressed;
        },
        onTap: (){
          if (widget.buttonType != ButtonType.Disabled)
              widget.onPressed();
        },
      ),
      duration: Duration(milliseconds:20),
    );
  }
}

enum ButtonType {LightBlue, Disabled }
// enum ButtonType {LightBlue, Straw, Disabled, DarkGray, DarkBlue }