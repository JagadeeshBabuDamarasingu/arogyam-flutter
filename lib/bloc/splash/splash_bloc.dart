import 'package:arogyam/data/auth_repository.dart';
import 'package:arogyam/data/preference_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'splash_event.dart';

part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(Loading()) {
    debugPrint("initialized");
    on<OnInitialize>((event, emit) async {
      debugPrint("OnInitialize: ${event.toString()}");
      final userLoggedIn = await Future.wait([
        Future.delayed(const Duration(seconds: 3)),
        PreferencesHelper.getUser().then((value) => value.isNotEmpty).onError(
          (error, stackTrace) {
            debugPrintStack(stackTrace: stackTrace);
            return false;
          },
        )
      ]);

      emit(OnInitialized(isLoggedIn: userLoggedIn[1]));
    });
  }
}
