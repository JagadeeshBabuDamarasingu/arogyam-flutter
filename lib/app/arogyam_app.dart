import 'package:arogyam/app/app_routes.dart';
import 'package:arogyam/bloc/admin/admin_bloc.dart';
import 'package:arogyam/bloc/auth/auth_bloc.dart';
import 'package:arogyam/bloc/slots/slot_list_bloc.dart';
import 'package:arogyam/bloc/splash/splash_bloc.dart';
import 'package:arogyam/bloc/user/user_bloc.dart';
import 'package:arogyam/bloc/user/user_event.dart';
import 'package:arogyam/bloc/user/user_state.dart';
import 'package:arogyam/data/SlotRepository.dart';
import 'package:arogyam/data/admin_repository.dart';
import 'package:arogyam/data/auth_repository.dart';
import 'package:arogyam/data/user_repository.dart';
import 'package:arogyam/res/app_theme.dart';
import 'package:arogyam/res/strings.dart';
import 'package:arogyam/screens/admin/admin_dashboard_screen.dart';
import 'package:arogyam/screens/auth/auth_screen.dart';
import 'package:arogyam/screens/auth/sign_in_screen.dart';
import 'package:arogyam/screens/auth/sign_up_screen.dart';
import 'package:arogyam/screens/home_screen.dart';
import 'package:arogyam/screens/slot/slot_list_screen.dart';
import 'package:arogyam/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RunoArogyamApp extends StatelessWidget {
  const RunoArogyamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: appTheme,
      initialRoute: AppRoutes.root,
      routes: {
        AppRoutes.root: (context) {
          return BlocProvider<SplashBloc>(
            create: (context) => SplashBloc(),
            child: const SplashScreen(),
          );
        },
        AppRoutes.auth: (context) => const AuthScreen(),
        AppRoutes.login: (context) {
          return BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(const AuthRepository()),
            child: const SignInScreen(),
          );
        },
        AppRoutes.register: (context) {
          return BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(const AuthRepository()),
            child: const SignUpScreen(),
          );
        },
        AppRoutes.userHome: (context) {
          return BlocProvider<UserBloc>(
            create: (context) => UserBloc(UserRepository()),
            child: const HomeScreen(),
          );
        },
        AppRoutes.slotListScreen: (context) {
          return BlocProvider<SlotListBloc>(
            create: (context) => SlotListBloc(const SlotRepository()),
            child: const SlotListScreen(),
          );
        },
        AppRoutes.adminHome: (context) {
          return BlocProvider<AdminBloc>(
            create: (context) => AdminBloc(const AdminRepository()),
            child: const AdminDashboardScreen(),
          );
        },
      },
    );
  }
}
