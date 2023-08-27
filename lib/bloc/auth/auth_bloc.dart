import 'package:arogyam/bloc/auth/auth_event.dart';
import 'package:arogyam/bloc/auth/auth_state.dart';
import 'package:arogyam/data/api_helper.dart';
import 'package:arogyam/data/auth_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState?> {
  final AuthRepository _repository;

  AuthBloc(this._repository) : super(null) {
    on<LoginEvent>((event, emit) async {
      debugPrint("onLoginEvent: ${event.toMap()}");
      emit(const AuthLoading());
      try {
        final user = await _repository.logUser(event.toMap());
        emit(LoggedIn(user: user));
      } on ApiException catch (err) {
        debugPrint("Login Error: ${err.toString()}");
        emit(AuthError(message: err.toString()));
      }
    });

    on<RegisterEvent>((event, emit) async {
      emit(const AuthLoading());
      try {
        final user = await _repository.registerUser(event.registerMap);
        emit(LoggedIn(user: user));
      } on ApiException catch (err) {
        debugPrint("Register Error: ${err.toString()}");
        emit(AuthError(message: err.toString()));
      }
    });
  }
}
