// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/auth/user_provider.dart';
import 'package:todo_app/firebase_functions.dart';
import 'package:todo_app/home_screen.dart';
import 'package:todo_app/widgets/default_elevated_button.dart';
import 'package:todo_app/widgets/default_text_form_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  static const String routName = '/register';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  /* -------------------------------------------------------------------------- */
  /*                            Form Controllers & Keys                           */
  /* -------------------------------------------------------------------------- */
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* -------------------------------------------------------------------------- */
      /*                            App Bar Configuration                            */
      /* -------------------------------------------------------------------------- */
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.register),
      ),
      /* -------------------------------------------------------------------------- */
      /*                            Register Form Layout                             */
      /* -------------------------------------------------------------------------- */
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /* -------------------------------------------------------------------------- */
              /*                            Name Input Field                               */
              /* -------------------------------------------------------------------------- */
              DefaultTextFormField(
                controller: nameController,
                hintText: AppLocalizations.of(context)!.name,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
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
              /*                             Register Button                                */
              /* -------------------------------------------------------------------------- */
              DefaultElevatedButton(
                onPressed: register,
                label: AppLocalizations.of(context)!.register,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void register() {
    if (formKey.currentState!.validate()) {
      FirebaseFunctions.registerUser(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      ).then((userModel) {
        Provider.of<UserProvider>(context, listen: false).updateUser(userModel);
        Navigator.of(context).pushReplacementNamed(HomeScreen.routname);
      }).catchError((error) {
        String? errorMessage;
        if (error is FirebaseAuthException) {
          errorMessage = error.message;
        }
        Fluttertoast.showToast(
          msg: errorMessage ?? 'something went wrong',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: AppTheme.green,
          textColor: AppTheme.white,
          fontSize: 15.0,
        );
      });
    }
  }
}
