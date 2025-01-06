import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextStyle get displayLarge => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      );

  static TextStyle get displayMedium => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      );

  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      );
}
