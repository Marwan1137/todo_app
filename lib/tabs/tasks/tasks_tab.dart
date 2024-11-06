import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/auth/user_provider.dart';
import 'package:todo_app/tabs/settings/settings_provider.dart';
import 'package:todo_app/tabs/tasks/tasks_provider.dart';
import 'task_item.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TasksTab extends StatefulWidget {
  const TasksTab({super.key});

  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  bool shouldGetTasks = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String userId =
          Provider.of<UserProvider>(context, listen: false).userModel!.id;
      Provider.of<TasksProvider>(context, listen: false).setUserId(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    TasksProvider tasksProvider = Provider.of<TasksProvider>(context);
    String userId = Provider.of<UserProvider>(context).userModel!.id;
    if (shouldGetTasks) {
      tasksProvider.getTasks(userId);
      shouldGetTasks = false;
    }
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: screenHeight * 0.15,
              width: double.infinity,
              color: AppTheme.primary,
            ),
            PositionedDirectional(
              start: 20,
              top: 40,
              child: Text(
                AppLocalizations.of(context)!.appTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Provider.of<SettingsProvider>(context).isDark
                          ? AppTheme.backgroundDark
                          : AppTheme.white,
                      fontSize: 22,
                    ),
              ),
            ),
            /* -------------------------------------------------------------------------- */
            /*                       Design of the Calender Section                       */
            /* -------------------------------------------------------------------------- */
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.1),
              child: EasyInfiniteDateTimeLine(
                firstDate: DateTime.now().subtract(
                  const Duration(days: 365),
                ),
                focusDate: tasksProvider.selectedDate,
                lastDate: DateTime.now().add(
                  const Duration(days: 365),
                ),
                onDateChange: (selectedDate) {
                  tasksProvider.changeSelectedDate(selectedDate, userId);
                  tasksProvider.getTasks(userId);
                },
                showTimelineHeader: false,
                activeColor: AppTheme.white,
                dayProps: EasyDayProps(
                  height: 79,
                  width: 58,
                  dayStructure: DayStructure.dayStrDayNum,
                  /* -------------------------------------------------------------------------- */
                  /*                              active selection Style                       */
                  /* -------------------------------------------------------------------------- */
                  activeDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    dayNumStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                    dayStrStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                  /* -------------------------------------------------------------------------- */
                  /*                            Today Selection Style                           */
                  /* -------------------------------------------------------------------------- */
                  todayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: Provider.of<SettingsProvider>(context).isDark
                          ? AppTheme.backgroundDark
                          : AppTheme.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    dayNumStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Provider.of<SettingsProvider>(context).isDark
                          ? AppTheme.white
                          : AppTheme.black,
                    ),
                    dayStrStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Provider.of<SettingsProvider>(context).isDark
                          ? AppTheme.white
                          : AppTheme.black,
                    ),
                  ),

                  /* -------------------------------------------------------------------------- */
                  /*                             inactive selection Style                   */
                  /* -------------------------------------------------------------------------- */
                  inactiveDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: Provider.of<SettingsProvider>(context).isDark
                          ? AppTheme.backgroundDark
                          : AppTheme.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    dayNumStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Provider.of<SettingsProvider>(context).isDark
                          ? AppTheme.white
                          : AppTheme.black,
                    ),
                    dayStrStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Provider.of<SettingsProvider>(context).isDark
                          ? AppTheme.white
                          : AppTheme.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
          /* -------------------------------------------------------------------------- */
          /* -------------------------------------------------------------------------- */
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemBuilder: (_, index) => TaskItem(
              tasksProvider.tasks[index],
            ),
            itemCount: tasksProvider.tasks.length,
          ),
        ),
      ],
    );
  }
}
