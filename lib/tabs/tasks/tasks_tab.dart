import 'package:flutter/material.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/firebase_functions.dart';
import 'package:todo_app/models/task_model.dart';
import 'task_item.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';

class TasksTab extends StatefulWidget {
  const TasksTab({super.key});

  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  List<TaskModel> tasks = [];
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    if (tasks.isEmpty) {
      getTasks();
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
                'ToDo List',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.white,
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
                focusDate: DateTime.now(),
                lastDate: DateTime.now().add(
                  const Duration(days: 365),
                ),
                showTimelineHeader: false,
                activeColor: AppTheme.white,
                dayProps: EasyDayProps(
                  height: 79,
                  width: 58,
                  dayStructure: DayStructure.dayStrDayNum,
                  /* -------------------------------------------------------------------------- */
                  /*                              active selection Design                       */
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
                  /*                             inactive selection Design                      */
                  /* -------------------------------------------------------------------------- */
                  inactiveDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    dayNumStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.black,
                    ),
                    dayStrStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.black,
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
              tasks[index],
            ),
            itemCount: tasks.length,
          ),
        ),
      ],
    );
  }

  Future<void> getTasks() async {
    tasks = await FirebaseFunctions.getAllTasksFromFirestore();
    setState(() {});
  }
}
