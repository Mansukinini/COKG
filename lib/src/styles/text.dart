import 'package:cokg/src/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class TestStyles {
  static TextStyle get navTitle {
    return GoogleFonts.poppins(
        textStyle:
            TextStyle(color: AppColors.darkblue, fontWeight: FontWeight.bold));
  }

  static TextStyle get navTitleMaterial {
    return GoogleFonts.poppins(
        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
  }
}