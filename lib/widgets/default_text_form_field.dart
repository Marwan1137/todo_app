import 'package:flutter/material.dart';
import 'package:todo_app/app_theme.dart';

// ignore: must_be_immutable
class DefaultTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool isDark;

  const DefaultTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: isDark ? AppTheme.white.withOpacity(0.7) : Colors.grey,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: isDark ? AppTheme.white : Colors.grey,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: isDark ? AppTheme.primary : Colors.blue,
          ),
        ),
      ),
      style: TextStyle(
        color: isDark ? AppTheme.white : AppTheme.black,
      ),
    );
  }
}
