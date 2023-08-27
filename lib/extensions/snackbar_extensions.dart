import 'package:arogyam/enums/snackbar_type.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

extension SnackBarExtensions on BuildContext {
  void showSnackBar(String message, {SnackBarType type = SnackBarType.info}) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.fixed,
      content: Text(
        message,
        style: GoogleFonts.raleway(
          color: Colors.white,
        ),
      ),
      backgroundColor: type.bgColor,
    ));
  }
}
