import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  primarySwatch: Colors.purple,
  textTheme: GoogleFonts.robotoTextTheme(),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
    floatingLabelBehavior: FloatingLabelBehavior.always,
  ),
);
