import 'package:cokg/src/styles/base.dart';
import 'package:cokg/src/styles/color.dart';
import 'package:cokg/src/styles/text.dart';
import 'package:flutter/material.dart';

abstract class TextFieldStyles {
  static Color get cursorColor => AppColors.darkblue;

  static TextStyle get placeholder => TextStyles.suggestion;

  static TextStyle get text => TextStyles.body;

  static Widget iconPrefix(IconData icon) => BaseStyles.iconPrefix(icon);

  static InputDecoration materialDecoration(String hintText, IconData icon, String errorText) 
  {
    return InputDecoration(
      contentPadding: EdgeInsets.all(8.0),
      hintText: hintText,
      hintStyle: TextFieldStyles.placeholder,
      border: InputBorder.none,
      errorText: errorText,
      errorStyle: TextStyles.error,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.straw, width: BaseStyles.borderWith),
        borderRadius: BorderRadius.circular(BaseStyles.borderRadius)
      ),

      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.straw, width: BaseStyles.borderWith),
        borderRadius: BorderRadius.circular(BaseStyles.borderRadius)
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.straw, width: BaseStyles.borderWith),
        borderRadius: BorderRadius.circular(BaseStyles.borderRadius)
      ),

      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.red, width: BaseStyles.borderWith),
        borderRadius: BorderRadius.circular(BaseStyles.borderRadius)
      ),
      prefixIcon: icon != null ? iconPrefix(icon) : null
    );
  }
}