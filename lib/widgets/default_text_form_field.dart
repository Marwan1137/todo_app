/* -------------------------------------------------------------------------- */
/*                         Custom Text Form Field Widget                      */
/* -------------------------------------------------------------------------- */
import 'package:flutter/material.dart';
import 'package:todo_app/app_theme.dart';

class DefaultTextFormField extends StatefulWidget {
  /* -------------------------------------------------------------------------- */
  /*                            Widget Properties                               */
  /* -------------------------------------------------------------------------- */
  // Controls and manages the text input state
  final TextEditingController controller;
  // Placeholder text displayed when the field is empty
  final String hintText;
  // Optional function for input validation
  final String? Function(String?)? validator;
  // Controls the color scheme based on dark/light mode
  final bool isDark;
  // Determines if the field should behave as a password input
  final bool isPassword;

  /* -------------------------------------------------------------------------- */
  /*                            Widget Constructor                              */
  /* -------------------------------------------------------------------------- */
  const DefaultTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    required this.isDark,
    this.isPassword = false,
  });

  @override
  State<DefaultTextFormField> createState() => _DefaultTextFormFieldState();
}

class _DefaultTextFormFieldState extends State<DefaultTextFormField> {
  /* -------------------------------------------------------------------------- */
  /*                            State Variables                                 */
  /* -------------------------------------------------------------------------- */
  // Controls the visibility of password text
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    /* -------------------------------------------------------------------------- */
    /*                            Form Field Widget                               */
    /* -------------------------------------------------------------------------- */
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: widget.isPassword ? _obscureText : false,

      /* -------------------------------------------------------------------------- */
      /*                            Field Decoration                                */
      /* -------------------------------------------------------------------------- */
      decoration: InputDecoration(
        hintText: widget.hintText,
        // Conditional password visibility toggle
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppTheme.grey,
                ),
              )
            : null,
        /* -------------------------------------------------------------------------- */
        /*                            Text Styling                                    */
        /* -------------------------------------------------------------------------- */
        hintStyle: TextStyle(
          color: widget.isDark ? AppTheme.white.withOpacity(0.7) : Colors.grey,
        ),

        /* -------------------------------------------------------------------------- */
        /*                            Border Configuration                            */
        /* -------------------------------------------------------------------------- */
        // Default state border styling
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: widget.isDark ? AppTheme.white : Colors.grey,
          ),
        ),
        // Active/focused state border styling
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: widget.isDark ? AppTheme.primary : Colors.blue,
          ),
        ),
      ),

      /* -------------------------------------------------------------------------- */
      /*                            Input Text Styling                              */
      /* -------------------------------------------------------------------------- */
      style: TextStyle(
        color: widget.isDark ? AppTheme.white : AppTheme.black,
      ),
    );
  }
}
