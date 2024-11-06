/* -------------------------------------------------------------------------- */
/*                         Custom Elevated Button Widget                        */
/* -------------------------------------------------------------------------- */
import 'package:flutter/material.dart';
import 'package:todo_app/app_theme.dart';

class DefaultElevatedButton extends StatelessWidget {
  /* -------------------------------------------------------------------------- */
  /*                            Widget Properties                                 */
  /* -------------------------------------------------------------------------- */
  final String label;
  final VoidCallback onPressed;

  /* -------------------------------------------------------------------------- */
  /*                            Widget Constructor                                */
  /* -------------------------------------------------------------------------- */
  const DefaultElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    /* -------------------------------------------------------------------------- */
    /*                            Button Widget Build                              */
    /* -------------------------------------------------------------------------- */
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(MediaQuery.sizeOf(context).width, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w400,
              color: AppTheme.white,
            ),
      ),
    );
  }
}
