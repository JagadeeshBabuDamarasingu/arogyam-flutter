import 'package:arogyam/res/strings.dart';
import 'package:arogyam/widgets/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleView extends StatelessWidget {
  final double? fontSize;

  const TitleView({
    this.fontSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GradientText(
      text: appName.toUpperCase(),
      textStyle: GoogleFonts.raleway(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
      gradientColors: [
        Colors.blueGrey[600]!,
        Colors.blueGrey,
        Colors.green,
        Colors.lightGreen,
        Colors.greenAccent,
      ],
    );
  }
}
