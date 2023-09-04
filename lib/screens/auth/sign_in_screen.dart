import 'package:arogyam/app/app_routes.dart';
import 'package:arogyam/bloc/auth/auth_bloc.dart';
import 'package:arogyam/bloc/auth/auth_event.dart';
import 'package:arogyam/bloc/auth/auth_state.dart';
import 'package:arogyam/constants.dart';
import 'package:arogyam/enums/snackbar_type.dart';
import 'package:arogyam/extensions/snackbar_extensions.dart';
import 'package:arogyam/screens/home_screen.dart';
import 'package:arogyam/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _openHomeScreen() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.userHome,
      (route) => false,
    );
  }

  void _onSignInClicked() {
    if (_formKey.currentState?.validate() == true) {
      debugPrint("sign in form is valid!");

      _formKey.currentState?.save();
      final phoneNumber = _phoneController.value.text;
      final password = _passwordController.value.text;
      context.read<AuthBloc>().add(
            LoginEvent(
              phoneNumber: phoneNumber,
              password: password,
            ),
          );
    }
  }

  void _listener(BuildContext context, AuthState? state) {
    if (state is AuthError) {
      context.showSnackBar(state.message, type: SnackBarType.error);
      return;
    }

    if (state is LoggedIn) {
      context.showSnackBar(
        "Welcome! ${state.user.name}",
        type: SnackBarType.success,
      );
      _openHomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SIGN IN"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
          child: Form(
            key: _formKey,
            child: BlocConsumer<AuthBloc, AuthState?>(
              listener: _listener,
              builder: (context, state) {
                return Column(
                  children: [
                    TextFormField(
                      maxLength: 10,
                      controller: _phoneController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormInputFieldValidator.compose([
                        FormInputFieldValidator.required(),
                        FormInputFieldValidator.minLength(minLength: 3),
                        FormInputFieldValidator.maxLength(maxLength: 10),
                      ]),
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        isDense: true,
                        prefixText: "+91 ",
                        prefixIconConstraints: BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                        labelText: 'Phone Number',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormInputFieldValidator.compose([
                        FormInputFieldValidator.required(),
                      ]),
                      onSaved: (value) {},
                      decoration: const InputDecoration(
                        isDense: true,
                        labelText: 'Password',
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (state is AuthLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    if (state is! AuthLoading)
                      Hero(
                        tag: signInTitleTag,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 36),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          onPressed: _onSignInClicked,
                          child: const Text("SIGN IN"),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
