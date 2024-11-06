import 'package:flutter/material.dart';
import 'package:todo_app/tabs/tasks/add_task_bottom_sheet.dart';
import 'app_theme.dart';
import 'tabs/settings/settings_tab.dart';
import 'tabs/tasks/tasks_tab.dart';

class HomeScreen extends StatefulWidget {
  static const String routname = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> tabs = [
    const TasksTab(),
    const SettingsTab(),
  ];
  int currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentTabIndex],

      /* -------------------------------------------------------------------------- */
      /*                            Bottom Navigation Bar                            */
      /* -------------------------------------------------------------------------- */
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: AppTheme.white,
        padding: EdgeInsets.zero,
        child: BottomNavigationBar(
          currentIndex: currentTabIndex,
          onTap: (index) => setState(() => currentTabIndex = index),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              label: 'Tasks',
              icon: Icon(Icons.list),
            ),
            BottomNavigationBarItem(
              label: 'Settings',
              icon: Icon(Icons.settings),
            ),
          ],
        ),
      ),

      /* -------------------------------------------------------------------------- */
      /*                            Floating Action Button                           */
      /* -------------------------------------------------------------------------- */
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (_) => const AddTasksBottomSheet(),
          isScrollControlled: true,
        ),
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
