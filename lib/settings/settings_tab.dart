import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/tabs/settings/settings_provider.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Dark Mode Switch
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.theme),
              Switch(
                value: settingsProvider.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  settingsProvider
                      .changeTheme(value ? ThemeMode.dark : ThemeMode.light);
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Language Selection
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.language),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButton<String>(
                  value: settingsProvider.languageCode,
                  items: [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'ar', child: Text('العربية')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      settingsProvider.changeLanguage(value);
                    }
                  },
                  underline: Container(), // removes the default underline
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
