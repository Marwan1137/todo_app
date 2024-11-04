import 'package:flutter/material.dart';
import 'package:todo_app/widgets/default_elevated_button.dart';
import 'package:todo_app/widgets/default_text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  static const String routName = '/register';

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
        title: const Text('Register'),
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
                hintText: 'Name',
                isDark: true,
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      value.length < 6) {
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
                onPressed: register,
                label: 'Register',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void register() {
    if (formKey.currentState!.validate()) {
      print('Register');
    }
  }
}
