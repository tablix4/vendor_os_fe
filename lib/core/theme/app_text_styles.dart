import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  // ============================================================
  // DISPLAY / AUTH HEADINGS
  // ============================================================

  static final TextStyle display = GoogleFonts.poppins(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: const Color(0xff0F172A),
  );

  // ============================================================
  // PAGE HEADING
  // Dashboard, Menu, Orders, Profile, Categories
  // ============================================================

  static final TextStyle heading = GoogleFonts.poppins(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: const Color(0xff0F172A),
  );

  // ============================================================
  // SECTION TITLE
  // Recent Orders, Menu Items, Order Summary
  // ============================================================

  static final TextStyle title = GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: const Color(0xff0F172A),
  );

  // ============================================================
  // SUBTITLE
  // ============================================================

  static final TextStyle subtitle = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.35,
    color: const Color(0xff0F172A),
  );

  // ============================================================
  // BODY
  // ============================================================

  static final TextStyle body = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.45,
    color: const Color(0xff334155),
  );

  static final TextStyle bodyMedium = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.45,
    color: const Color(0xff334155),
  );

  static final TextStyle bodySemiBold = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.45,
    color: const Color(0xff0F172A),
  );

  // ============================================================
  // LABEL
  // Category Name, Price, Description etc.
  // ============================================================

  static final TextStyle label = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: const Color(0xff334155),
  );

  // ============================================================
  // CAPTION
  // ============================================================

  static final TextStyle caption = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: const Color(0xff64748B),
  );

  // ============================================================
  // SMALL
  // ============================================================

  static final TextStyle small = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.35,
    color: const Color(0xff64748B),
  );

  // ============================================================
  // BUTTON
  // ============================================================

  static final TextStyle button = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
}
