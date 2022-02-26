import 'package:cokg/src/styles/base.dart';
import 'package:cokg/src/styles/button.dart';
import 'package:cokg/src/styles/color.dart';
import 'package:cokg/src/styles/text.dart';
import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {

  final String labelText;
  final ButtonType buttonType;
  final Widget icon;
  final bool isAnimatedButton;
  final void Function() onPressed;

  AppButton({
    @required this.labelText,
    this.isAnimatedButton = true,
    this.buttonType,
    this.icon,
    this.onPressed
  });

  @override
  _AppButtonState createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) {

    if (widget.isAnimatedButton){
      return animatedContainer();
    } else {
      return elevatedButton();
    }
  }

  Widget animatedContainer() {
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

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: AnimatedContainer(
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
      ),
    );
  }

  Widget elevatedButton() {
    TextStyle fontStyle;

    return Padding(
      padding: const EdgeInsets.only(top: 10.0, right: 12.0, left: 12.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          primary: Colors.brown,
          onPrimary: Colors.white,
          minimumSize: Size(double.infinity, 25),
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(7.0)),
          fixedSize: Size(MediaQuery.of(context).size.width,ButtonStyles.buttonHeight),
          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        icon: widget.icon,
        onPressed: widget.onPressed,
        label: Text(widget.labelText, style: fontStyle),
      ),
    );
  }
}

enum ButtonType {LightBlue, Disabled }