import 'package:arogyam/app/app_routes.dart';
import 'package:arogyam/constants.dart';
import 'package:arogyam/res/strings.dart';
import 'package:arogyam/widgets/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  void _onSignInClicked() {
    Navigator.pushNamed(context, AppRoutes.login);
  }

  void _onSignUpClicked() {
    Navigator.pushNamed(context, AppRoutes.register);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Hero(
              tag: splashHeroTag,
              child: Column(
                children: [
                  Lottie.asset("assets/json/lottie/vaccination.json"),
                  GradientText(
                    text: appName.toUpperCase(),
                    textStyle: GoogleFonts.raleway(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                    gradientColors: [
                      Colors.blueGrey[600]!,
                      Colors.blueGrey,
                      Colors.green,
                      Colors.lightGreen,
                      Colors.greenAccent,
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  side: const BorderSide(color: Colors.blue),
                ),
                onPressed: _onSignInClicked,
                child: Hero(
                  tag: signInTitleTag,
                  child: Text(
                    "SIGN IN",
                    style: GoogleFonts.raleway(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  side: const BorderSide(color: Colors.blue),
                ),
                onPressed: _onSignUpClicked,
                child: Hero(
                  tag: signUpTitleTag,
                  child: Text(
                    "SIGN UP",
                    style: GoogleFonts.raleway(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
