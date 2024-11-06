/* -------------------------------------------------------------------------- */
/*                            Required Imports                                  */
/* -------------------------------------------------------------------------- */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/tabs/settings/settings_provider.dart';

/* -------------------------------------------------------------------------- */
/*                            Language Bottom Sheet Widget                      */
/* -------------------------------------------------------------------------- */
class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    /* -------------------------------------------------------------------------- */
    /*                            Provider & Theme Setup                           */
    /* -------------------------------------------------------------------------- */
    final settingsProvider = Provider.of<SettingsProvider>(context);
    bool isDark = settingsProvider.isDark;

    /* -------------------------------------------------------------------------- */
    /*                            Main Container Layout                            */
    /* -------------------------------------------------------------------------- */
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.backgroundDark : AppTheme.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      /* -------------------------------------------------------------------------- */
      /*                            Language Options List                            */
      /* -------------------------------------------------------------------------- */
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /* -------------------------------------------------------------------------- */
          /*                            English Language Option                          */
          /* -------------------------------------------------------------------------- */
          LanguageOption(
            title: 'English',
            isSelected: settingsProvider.languageCode == 'en',
            onTap: () {
              settingsProvider.changeLanguage('en');
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 15),
          /* -------------------------------------------------------------------------- */
          /*                            Arabic Language Option                           */
          /* -------------------------------------------------------------------------- */
          LanguageOption(
            title: 'العربية',
            isSelected: settingsProvider.languageCode == 'ar',
            onTap: () {
              settingsProvider.changeLanguage('ar');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                            Language Option Widget                            */
/* -------------------------------------------------------------------------- */
class LanguageOption extends StatelessWidget {
  /* -------------------------------------------------------------------------- */
  /*                            Widget Properties                                 */
  /* -------------------------------------------------------------------------- */
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageOption({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<SettingsProvider>(context).isDark;

    /* -------------------------------------------------------------------------- */
    /*                            Option Button Layout                             */
    /* -------------------------------------------------------------------------- */
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.black : AppTheme.white,
          border: Border.all(
            color: isSelected ? AppTheme.primary : Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        /* -------------------------------------------------------------------------- */
        /*                            Option Content Layout                            */
        /* -------------------------------------------------------------------------- */
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /* -------------------------------------------------------------------------- */
            /*                            Language Title                                   */
            /* -------------------------------------------------------------------------- */
            Text(
              title,
              style: TextStyle(
                color: isDark ? AppTheme.white : AppTheme.black,
                fontSize: 16,
              ),
            ),
            /* -------------------------------------------------------------------------- */
            /*                            Selection Indicator                              */
            /* -------------------------------------------------------------------------- */
            if (isSelected)
              const Icon(
                Icons.check,
                color: AppTheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}
