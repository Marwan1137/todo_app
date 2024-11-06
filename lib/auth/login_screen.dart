// ignore_for_file: avoid_print

/* -------------------------------------------------------------------------- */
/*                            Login Screen Widget                               */
/* -------------------------------------------------------------------------- */
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/auth/user_provider.dart';
import 'package:todo_app/firebase_functions.dart';
import 'package:todo_app/home_screen.dart';
import 'package:todo_app/widgets/default_elevated_button.dart';
import 'package:todo_app/widgets/default_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  static const String routName = '/login';

  const LoginScreen({super.key});

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
        title: Text(AppLocalizations.of(context)!.login),
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
                hintText: AppLocalizations.of(context)!.email,
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
                hintText: AppLocalizations.of(context)!.password,
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
                label: AppLocalizations.of(context)!.login,
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
                  child: Text(
                    AppLocalizations.of(context)!.dontHaveAnAccount,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.titleSmall?.color,
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
  void login() async {
    if (formKey.currentState!.validate()) {
      try {
        final userModel = await FirebaseFunctions.loginUser(
          email: emailController.text,
          password: passwordController.text,
        );

        if (!mounted) return;

        Provider.of<UserProvider>(context, listen: false).updateUser(userModel);
        Navigator.of(context).pushReplacementNamed(HomeScreen.routname);
      } catch (error) {
        String errorMessage = error.toString();
        if (error is FirebaseAuthException) {
          errorMessage = error.message ?? 'Authentication failed';
        }

        Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: AppTheme.red,
          textColor: AppTheme.white,
          fontSize: 15.0,
        );
      }
    }
  }
}
