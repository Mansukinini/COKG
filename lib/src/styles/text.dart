import 'package:cokg/src/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class TextStyles {
  static TextStyle get navTitle {
    return GoogleFonts.roboto(
      textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w400));
  }

  static TextStyle get navTitleMaterial {
    return GoogleFonts.poppins(
        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w400));
  }

  static TextStyle get title {
    return GoogleFonts.poppins(
        textStyle: TextStyle(
            color: AppColors.straw,
            fontWeight: FontWeight.w500,
            fontSize: 18.0));
  }

  static TextStyle get subtitle {
    return GoogleFonts.roboto(
        textStyle: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.w400,
            fontSize: 14.0));
  }

  static TextStyle get body {
    return GoogleFonts.roboto(
        textStyle: TextStyle(color: AppColors.black, fontSize: 20.0, height: 1.4));
  }

  static TextStyle get suggestion {
    return GoogleFonts.roboto(
        textStyle: TextStyle(color: AppColors.black, fontSize: 14.0));
  }

  static TextStyle get actionText {
    return GoogleFonts.roboto(
        textStyle: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.w400));
  }

  static TextStyle get error {
    return GoogleFonts.roboto(
        textStyle: TextStyle(color: AppColors.red, fontSize: 12.0));
  }

  static TextStyle get buttonTextLight {
    return GoogleFonts.roboto(
      textStyle: TextStyle(
        color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold));
  }

  static TextStyle get buttonTextBlack {
    return GoogleFonts.roboto(
      textStyle: TextStyle(
        fontSize: 20.0, fontWeight: FontWeight.w500));
  }

  static TextStyle get buttonText {
    return GoogleFonts.roboto(
      textStyle: TextStyle(
        fontSize: 20.0, fontWeight: FontWeight.w500));
  }
}