import 'package:arogyam/bloc/app_event.dart';

sealed class AuthEvent extends AppEvent {
  const AuthEvent();
}

class RegisterEvent extends AuthEvent {
  final Map<String, dynamic> registerMap;

  const RegisterEvent({required this.registerMap});

  @override
  List<Object> get props => [registerMap];
}

class LoginEvent extends AuthEvent {
  final String phoneNumber;
  final String password;

  const LoginEvent({
    required this.phoneNumber,
    required this.password,
  });

  @override
  List<Object> get props => [phoneNumber, password];

  Map<String, dynamic> toMap() => {
        'phone': phoneNumber,
        'password': password,
      };
}
