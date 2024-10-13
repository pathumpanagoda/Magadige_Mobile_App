import 'package:flutter/material.dart';
import 'package:magadige/modules/auth/service.dart';
import 'package:magadige/modules/home/view.dart';
import 'package:magadige/utils/index.dart';
import 'package:magadige/widgets/app.logo.dart';
import 'package:magadige/widgets/custom.filled.button.dart';
import 'package:magadige/widgets/custom.input.field.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  final _key = GlobalKey<FormState>();

  bool loading = false;

  // Email validation
  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Password validation
  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  // Confirm password validation
  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Signup",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF2A2A2A),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppLogo(),
                const SizedBox(height: 32),
                // Email input field with validation
                CustomInputField(
                  label: "Email",
                  hint: "example@gmail.com",
                  controller: _emailController,
                  inputType: TextInputType.emailAddress,
                  validator: _emailValidator,
                ),
                const SizedBox(height: 16),
                // Password input field with validation
                CustomInputField(
                  label: "Password",
                  hint: "******",
                  controller: _passwordController,
                  isPassword: true,
                  validator: _passwordValidator,
                ),
                const SizedBox(height: 16),
                // Confirm password input field with validation
                CustomInputField(
                  label: "Confirm Password",
                  hint: "******",
                  controller: _confirmPasswordController,
                  isPassword: true,
                  validator: _confirmPasswordValidator,
                ),
                const SizedBox(height: 16),
                // Signup button
                CustomButton(
                  text: "Signup",
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      setState(() {
                        loading = true;
                      });
                      await _authService
                          .signUpWithEmailAndPassword(
                              _emailController.text, _passwordController.text)
                          .then((value) {
                        context.navigator(context, const HomeView(),
                            shouldBack: false);
                      }).catchError((err) {
                        context
                            .showSnackBar('Error signing up, please try again');
                      });
                      setState(() {
                        loading = false;
                      });
                    }
                  },
                  loading: loading,
                ),
                const SizedBox(height: 16),
                // Redirect to login page link
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Go back to login
                        },
                        child: const Text("Login"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
