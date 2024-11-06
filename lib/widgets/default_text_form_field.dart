/* -------------------------------------------------------------------------- */
/*                         Custom Text Form Field Widget                        */
/* -------------------------------------------------------------------------- */
import 'package:flutter/material.dart';
import 'package:todo_app/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/tabs/settings/settings_provider.dart';

class DefaultTextFormField extends StatefulWidget {
  /* -------------------------------------------------------------------------- */
  /*                            Widget Properties                                 */
  /* -------------------------------------------------------------------------- */
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool isPassword;

  /* -------------------------------------------------------------------------- */
  /*                            Widget Constructor                                */
  /* -------------------------------------------------------------------------- */
  const DefaultTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.isPassword = false,
  });

  @override
  State<DefaultTextFormField> createState() => _DefaultTextFormFieldState();
}

class _DefaultTextFormFieldState extends State<DefaultTextFormField> {
  /* -------------------------------------------------------------------------- */
  /*                            State Variables                                   */
  /* -------------------------------------------------------------------------- */
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final isDark = settingsProvider.isDark;

    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: widget.isPassword ? _obscureText : false,

      /* -------------------------------------------------------------------------- */
      /*                            Field Decoration                                 */
      /* -------------------------------------------------------------------------- */
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () => setState(() => _obscureText = !_obscureText),
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: isDark ? AppTheme.white : AppTheme.black,
                ),
              )
            : null,

        /* -------------------------------------------------------------------------- */
        /*                            Text Styling                                     */
        /* -------------------------------------------------------------------------- */
        hintStyle: TextStyle(
          color: isDark ? AppTheme.white.withOpacity(0.7) : Colors.grey,
        ),

        /* -------------------------------------------------------------------------- */
        /*                            Border Configuration                             */
        /* -------------------------------------------------------------------------- */
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: isDark ? AppTheme.white : Colors.grey,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.primary,
          ),
        ),
      ),

      /* -------------------------------------------------------------------------- */
      /*                            Input Text Styling                               */
      /* -------------------------------------------------------------------------- */
      style: TextStyle(
        color: isDark ? AppTheme.white : AppTheme.black,
      ),
    );
  }
}
