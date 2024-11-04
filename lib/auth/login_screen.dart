/* -------------------------------------------------------------------------- */
/*                            Login Screen Widget                               */
/* -------------------------------------------------------------------------- */
import 'package:flutter/material.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/widgets/default_elevated_button.dart';
import 'package:todo_app/widgets/default_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  static const String routName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /* -------------------------------------------------------------------------- */
  /*                            Form Controllers & Keys                           */
  /* -------------------------------------------------------------------------- */
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* -------------------------------------------------------------------------- */
      /*                            App Bar Configuration                            */
      /* -------------------------------------------------------------------------- */
      appBar: AppBar(
        title: const Text('Login'),
      ),
      /* -------------------------------------------------------------------------- */
      /*                            Login Form Layout                                */
      /* -------------------------------------------------------------------------- */
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /* -------------------------------------------------------------------------- */
              /*                            Email Input Field                               */
              /* -------------------------------------------------------------------------- */
              DefaultTextFormField(
                controller: emailController,
                hintText: 'Email',
                isDark: true,
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      value.length < 6) {
                    return 'Email is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              /* -------------------------------------------------------------------------- */
              /*                            Password Input Field                            */
              /* -------------------------------------------------------------------------- */
              DefaultTextFormField(
                controller: passwordController,
                hintText: 'password',
                isDark: true,
                isPassword: true,
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      value.length < 6) {
                    return 'Password is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 80),
              /* -------------------------------------------------------------------------- */
              /*                            Login Button                                    */
              /* -------------------------------------------------------------------------- */
              DefaultElevatedButton(
                onPressed: login,
                label: 'Login',
              ),
              const SizedBox(height: 50),
              /* -------------------------------------------------------------------------- */
              /*                            Register Link Text                               */
              /* -------------------------------------------------------------------------- */
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: const Text(
                    "Don't have an account? Register here",
                    style: TextStyle(
                      color: AppTheme.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                            Login Form Handler                               */
  /* -------------------------------------------------------------------------- */
  void login() {
    if (formKey.currentState!.validate()) {
      print(emailController.text);
      print(passwordController.text);
    }
  }
}
