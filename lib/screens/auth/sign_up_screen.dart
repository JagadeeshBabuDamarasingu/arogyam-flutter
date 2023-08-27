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

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final Map<String, dynamic> registerMap = {};
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  FormFieldValidator bothPasswordsMatch() {
    return (valueCandidate) {
      final password = _passwordController.value.text;
      if (valueCandidate == null || valueCandidate != password) {
        return 'passwords do not match';
      }
      return null;
    };
  }

  void _onSignUpClicked() {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();
      debugPrint("sign up form is valid!");
      context.read<AuthBloc>().add(RegisterEvent(registerMap: registerMap));
    }
  }

  void _openHomeScreen() {
    final newRoute = MaterialPageRoute(
      builder: (context) => const HomeScreen(),
    );
    Navigator.of(context).pushAndRemoveUntil(newRoute, (route) => false);
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
        title: const Hero(
          tag: signUpTitleTag,
          child: Text("SIGN UP"),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: BlocConsumer<AuthBloc, AuthState?>(
                  listener: _listener,
                  builder: (context, state) {
                    return Column(
                      children: [
                        const SizedBox(height: 16),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onSaved: (value) => registerMap['name'] = value,
                          validator: FormInputFieldValidator.compose([
                            FormInputFieldValidator.required(),
                            FormInputFieldValidator.minLength(minLength: 3)
                          ]),
                          decoration: const InputDecoration(
                            isDense: true,
                            labelText: 'Name',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          onSaved: (value) =>
                              registerMap['age'] = int.parse(value!),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: FormInputFieldValidator.compose([
                            FormInputFieldValidator.required(),
                          ]),
                          decoration: const InputDecoration(
                            isDense: true,
                            labelText: 'Age',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          maxLength: 6,
                          keyboardType: TextInputType.number,
                          onSaved: (value) =>
                              registerMap['pincode'] = int.parse(value!),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: FormInputFieldValidator.compose([
                            FormInputFieldValidator.required(),
                            FormInputFieldValidator.exactLength(length: 6)
                          ]),
                          decoration: const InputDecoration(
                            isDense: true,
                            labelText: 'Pin Code',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          maxLength: 10,
                          onSaved: (value) => registerMap['phone'] = value,
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
                          onSaved: (value) => registerMap['password'] = value,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: FormInputFieldValidator.compose([
                            FormInputFieldValidator.required(),
                            FormInputFieldValidator.minLength(minLength: 8)
                          ]),
                          decoration: const InputDecoration(
                            isDense: true,
                            labelText: 'Password',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          obscureText: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: FormInputFieldValidator.compose([
                            FormInputFieldValidator.required(),
                            FormInputFieldValidator.minLength(minLength: 8),
                            bothPasswordsMatch()
                          ]),
                          decoration: const InputDecoration(
                            isDense: true,
                            labelText: 'Confirm password',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          obscureText: true,
                          obscuringCharacter: "X",
                          maxLength: 12,
                          onSaved: (value) => registerMap['aadhar'] = value,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: FormInputFieldValidator.compose([
                            FormInputFieldValidator.required(),
                            FormInputFieldValidator.exactLength(length: 12)
                          ]),
                          decoration: const InputDecoration(
                            isDense: true,
                            labelText: 'Aadhar Number',
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
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 36),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            onPressed: _onSignUpClicked,
                            child: const Text("SIGN UP"),
                          )
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
