/* -------------------------------------------------------------------------- */
/*                            Main Application File                             */
/* -------------------------------------------------------------------------- */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/auth/login_screen.dart';
import 'package:todo_app/auth/register_screen.dart';
import 'package:todo_app/auth/user_provider.dart';
import 'package:todo_app/tabs/settings/settings_provider.dart';
import 'package:todo_app/tabs/tasks/tasks_provider.dart';
import 'home_screen.dart';
import 'app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  /* -------------------------------------------------------------------------- */
  /*                            Initialization                                    */
  /* -------------------------------------------------------------------------- */
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  /* -------------------------------------------------------------------------- */
  /*                            Application Setup                                 */
  /* -------------------------------------------------------------------------- */
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => settingsProvider),
        ChangeNotifierProvider(create: (context) => TasksProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: const TodoApp(),
    ),
  );
}

/* -------------------------------------------------------------------------- */
/*                            Root Application Widget                           */
/* -------------------------------------------------------------------------- */
class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            LoginScreen.routName: (_) => const LoginScreen(),
            RegisterScreen.routName: (_) => const RegisterScreen(),
            HomeScreen.routname: (_) => const HomeScreen(),
          },
          initialRoute: LoginScreen.routName,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settingsProvider.themeMode,
          locale: Locale(settingsProvider.languageCode),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],
          builder: (context, child) {
            return Directionality(
              textDirection: settingsProvider.languageCode == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: child!,
            );
          },
        );
      },
    );
  }
}
