import 'dart:async';

import 'package:arogyam/app/app_routes.dart';
import 'package:arogyam/bloc/splash/splash_bloc.dart';
import 'package:arogyam/constants.dart';
import 'package:arogyam/res/strings.dart';
import 'package:arogyam/screens/auth/auth_screen.dart';
import 'package:arogyam/screens/home_screen.dart';
import 'package:arogyam/widgets/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _openNextScreen(BuildContext context, {shouldOpenHome = true}) {
    final routeName = shouldOpenHome ? AppRoutes.userHome : AppRoutes.auth;
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    context.read<SplashBloc>().add(OnInitialize());
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        debugPrint("onListen: ${state.toString()}");
        if (state is OnInitialized) {
          _openNextScreen(context, shouldOpenHome: state.isLoggedIn);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Hero(
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
          ),
        ),
      ),
    );
  }
}
