import 'package:flutter/material.dart';
import 'package:todo_app/tabs/tasks/add_task_bottom_sheet.dart';
import 'app_theme.dart';
import 'tabs/settings/settings_tab.dart';
import 'tabs/tasks/tasks_tab.dart';

class HomeScreen extends StatefulWidget {
  static const String routname = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> tabs = [
    TasksTab(),
    SettingsTab(),
  ];
  int currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentTabIndex],

      /* -------------------------------------------------------------------------- */
      /*                  bottom side of the app in the home screen                 */
      /* -------------------------------------------------------------------------- */

      /* ------------------------ Section 1: bottom nav bar ----------------------- */
      bottomNavigationBar: BottomAppBar(
        /* -------------------------------------------------------------------------- */
        /*                       to make the nav bar with notch                       */
        /* -------------------------------------------------------------------------- */
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: AppTheme.white,
        padding: EdgeInsets.zero,
        /* -------------------------------------------------------------------------- */
        child: BottomNavigationBar(
          currentIndex: currentTabIndex,
          onTap: (index) => setState(
            () => currentTabIndex = index,
          ),
          elevation: 0,
          items: [
            /* -------------------- the 2 icons of the bottom navbar -------------------- */
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
      /*                       floating action button section                       */
      /* -------------------------------------------------------------------------- */
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
            context: context, builder: (_) => AddTasksBottomSheet()),
        child: Icon(
          Icons.add,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
