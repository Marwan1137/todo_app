import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/tabs/settings/language_bottom_sheet.dart';
import 'package:todo_app/tabs/settings/settings_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    bool isDark = settingsProvider.isDark;
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Container(
          height: screenHeight * 0.35,
          width: double.infinity,
          color: AppTheme.primary,
        ),
        PositionedDirectional(
          start: 20,
          top: 60,
          child: Text(
            AppLocalizations.of(context)!.settings,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: isDark ? AppTheme.backgroundDark : AppTheme.white,
                  fontSize: 22,
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 120),
          child: Container(
            color: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.language,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isDark ? AppTheme.white : AppTheme.black,
                      ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => const LanguageBottomSheet(),
                      backgroundColor: Colors.transparent,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.black : AppTheme.white,
                      border: Border.all(
                        color: AppTheme.primary,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          settingsProvider.languageCode == 'ar'
                              ? 'العربية'
                              : 'English',
                          style: TextStyle(
                            color: isDark ? AppTheme.white : AppTheme.black,
                            fontSize: 16,
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: isDark ? AppTheme.white : AppTheme.black,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  AppLocalizations.of(context)!.theme,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isDark ? AppTheme.white : AppTheme.black,
                      ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.black : AppTheme.white,
                    border: Border.all(
                      color: AppTheme.primary,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isDark
                            ? AppLocalizations.of(context)!.dark
                            : AppLocalizations.of(context)!.light,
                        style: TextStyle(
                          color: isDark ? AppTheme.white : AppTheme.black,
                          fontSize: 16,
                        ),
                      ),
                      Switch(
                        value: settingsProvider.themeMode == ThemeMode.dark,
                        onChanged: (isDark) => settingsProvider.changeTheme(
                          isDark ? ThemeMode.dark : ThemeMode.light,
                        ),
                        activeTrackColor: AppTheme.green,
                        activeColor: AppTheme.white,
                        inactiveTrackColor: Colors.grey,
                        inactiveThumbColor: AppTheme.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
