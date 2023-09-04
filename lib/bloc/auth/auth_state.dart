import 'package:arogyam/bloc/app_state.dart';
import 'package:arogyam/models/user.dart';

sealed class AuthState extends AppState {
  const AuthState();
}

class AuthLoading extends AuthState {
  final String message;

  const AuthLoading({this.message = "Loading, please wait"});
}

class AuthError extends AuthState {
  final String message;

  @override
  List<Object?> get props => [message];

  const AuthError({required this.message});
}

class LoggedIn extends AuthState {
  final User user;

  @override
  List<Object?> get props => [user];

  const LoggedIn({required this.user});
}
