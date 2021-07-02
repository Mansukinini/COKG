import 'package:cokg/src/styles/base.dart';
import 'package:cokg/src/styles/color.dart';
import 'package:cokg/src/styles/text.dart';
import 'package:flutter/material.dart';

abstract class TextFieldStyles {
  static Color get cursorColor => AppColors.darkblue;

  static TextStyle get placeholder => TextStyles.placeholder;

  static TextStyle get text => TextStyles.body;

  static Widget iconPrefix(IconData icon) => BaseStyles.iconPrefix(icon);

  static InputDecoration materialDecoration(String labelText, String hintText, IconData icon, String errorText) 
  {
    return InputDecoration(
      contentPadding: EdgeInsets.only(top: 2.0, left: 1.0, right: 1.0),
      labelText: labelText != null ? labelText : null,
      hintText: hintText != null ? hintText : null,
      hintStyle: TextFieldStyles.placeholder,
      errorText: errorText,
      errorStyle: TextStyles.error,
      
      // border: UnderlineInputBorder(
      //   borderRadius: BorderRadius.circular(BaseStyles.borderRadius)
      // ),

      // focusedBorder: UnderlineInputBorder(
      //   borderSide: BorderSide(color: AppColors.brown, width: BaseStyles.borderWith),
      //   // borderRadius: BorderRadius.circular(BaseStyles.borderRadius)
      // ),

      // enabledBorder: UnderlineInputBorder(
      //   borderSide: BorderSide(color: AppColors.brown, width: BaseStyles.borderWith),
      //   // borderRadius: BorderRadius.circular(BaseStyles.borderRadius)
      // ),

      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.brown, width: BaseStyles.borderWith),
        // borderRadius: BorderRadius.circular(BaseStyles.borderRadius)
      ),

      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.red, width: BaseStyles.borderWith),
        // borderRadius: BorderRadius.circular(BaseStyles.borderRadius)
      ),
      prefixIcon: icon != null ? iconPrefix(icon) : null
    );
  }

  static InputDecoration materialDecorationForFormField(String labelText, String hintText, IconData icon, String errorText) 
  {
    return InputDecoration(
      contentPadding: EdgeInsets.all(10.0),
      labelText: labelText != null ? labelText : null,
      hintText: hintText != null ? hintText : null,
      hintStyle: TextFieldStyles.placeholder,
      errorText: errorText,
      errorStyle: TextStyles.error,
      
      border: UnderlineInputBorder(
        // borderRadius: BorderRadius.circular(BaseStyles.borderRadius),
        borderSide: BorderSide(color: AppColors.brown, width: BaseStyles.borderWith)
      ),

      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.brown, width: BaseStyles.borderWith),
        // borderRadius: BorderRadius.circular(BaseStyles.borderRadius)
      ),

      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.brown, width: BaseStyles.borderWith),
        // borderRadius: BorderRadius.circular(BaseStyles.borderRadius)
      ),

      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.brown, width: BaseStyles.borderWith),
        // borderRadius: BorderRadius.circular(BaseStyles.borderRadius)
      ),

      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.red, width: BaseStyles.borderWith),
        // borderRadius: BorderRadius.circular(BaseStyles.borderRadius)
      ),
      prefixIcon: icon != null ? iconPrefix(icon) : null,
    );
  }
}