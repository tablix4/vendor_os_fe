import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static final TextStyle heading = GoogleFonts.poppins(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static final TextStyle title = GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static final TextStyle body = GoogleFonts.poppins(
    fontSize: 16,
    color: Colors.black87,
  );

  static final TextStyle caption = GoogleFonts.poppins(
    fontSize: 14,
    color: Colors.grey,
  );
}