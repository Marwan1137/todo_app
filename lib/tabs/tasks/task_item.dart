// ignore_for_file: use_build_context_synchronously

/* -------------------------------------------------------------------------- */
/*                            Required Imports                                  */
/* -------------------------------------------------------------------------- */

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/firebase_functions.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/tabs/tasks/tasks_provider.dart';
import 'package:todo_app/tabs/tasks/update_task_screen.dart';
import 'package:todo_app/tabs/settings/settings_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/* -------------------------------------------------------------------------- */
/*                            Task Item Widget                                  */
/* -------------------------------------------------------------------------- */
// ignore: must_be_immutable
class TaskItem extends StatelessWidget {
  TaskItem(this.task, {super.key});
  TaskModel task;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDark = Provider.of<SettingsProvider>(context).isDark;
    bool isArabic = Provider.of<SettingsProvider>(context).languageCode == 'ar';

    /* -------------------------------------------------------------------------- */
    /*                            Main Container Widget                             */
    /* -------------------------------------------------------------------------- */
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Slidable(
        /* -------------------------------------------------------------------------- */
        /*                            Left Slide Actions (LTR)                         */
        /* -------------------------------------------------------------------------- */
        startActionPane: isArabic
            ? null
            : ActionPane(
                motion: const ScrollMotion(),
                children: [
                  /* -------------------------------------------------------------------------- */
                  /*                            Delete Action Button                             */
                  /* -------------------------------------------------------------------------- */
                  SlidableAction(
                    onPressed: (_) async {
                      try {
                        final userId = FirebaseAuth.instance.currentUser?.uid;
                        if (userId == null) return;

                        print('Deleting task with ID: ${task.id}'); // Debug log

                        // Check if task ID exists
                        if (task.id.isEmpty) {
                          throw Exception('Task ID is empty');
                        }

                        // Delete from Firebase
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .collection('tasks')
                            .doc(task.id)
                            .delete();

                        // Update UI
                        if (!context.mounted) return;
                        await Provider.of<TasksProvider>(context, listen: false)
                            .getTasks(userId);

                        if (!context.mounted) return;
                        Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)!.taskDeleted,
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: AppTheme.green,
                          textColor: AppTheme.white,
                          fontSize: 16.0,
                        );
                      } catch (e) {
                        print('Error deleting task: $e'); // Debug log
                        if (!context.mounted) return;

                        Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)!.somethingWentWrong,
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: AppTheme.red,
                          textColor: AppTheme.white,
                          fontSize: 16.0,
                        );
                      }
                    },
                    backgroundColor: AppTheme.red,
                    foregroundColor: AppTheme.white,
                    icon: Icons.delete,
                    label: AppLocalizations.of(context)!.delete,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  /* -------------------------------------------------------------------------- */
                  /*                            Edit Action Button                               */
                  /* -------------------------------------------------------------------------- */
                  if (!task.isDone) ...[
                    const SizedBox(width: 5),
                    SlidableAction(
                      onPressed: (_) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => UpdateTaskScreen(task: task),
                          ),
                        );
                      },
                      backgroundColor: AppTheme.primary,
                      foregroundColor: AppTheme.white,
                      icon: Icons.edit,
                      label: AppLocalizations.of(context)!.edit,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ]
                ],
              ),

        /* -------------------------------------------------------------------------- */
        /*                            Right Slide Actions (RTL)                         */
        /* -------------------------------------------------------------------------- */
        endActionPane: isArabic
            ? ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (_) async {
                      try {
                        final userId = FirebaseAuth.instance.currentUser?.uid;
                        if (userId == null) return;

                        print('Deleting task with ID: ${task.id}'); // Debug log

                        // Check if task ID exists
                        if (task.id.isEmpty) {
                          throw Exception('Task ID is empty');
                        }

                        // Delete from Firebase
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .collection('tasks')
                            .doc(task.id)
                            .delete();

                        // Update UI
                        if (!context.mounted) return;
                        await Provider.of<TasksProvider>(context, listen: false)
                            .getTasks(userId);

                        if (!context.mounted) return;
                        Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)!.taskDeleted,
                          toastLength: Toast.LENGTH_LONG,
                          timeInSecForIosWeb: 5,
                          backgroundColor: AppTheme.green,
                          textColor: AppTheme.white,
                          fontSize: 16.0,
                        );
                      } catch (e) {
                        print('Error deleting task: $e'); // Debug log
                        if (!context.mounted) return;

                        Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)!.somethingWentWrong,
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: AppTheme.red,
                          textColor: AppTheme.white,
                          fontSize: 16.0,
                        );
                      }
                    },
                    backgroundColor: AppTheme.red,
                    foregroundColor: AppTheme.white,
                    icon: Icons.delete,
                    label: AppLocalizations.of(context)!.delete,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  if (!task.isDone) ...[
                    const SizedBox(width: 5),
                    SlidableAction(
                      onPressed: (_) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => UpdateTaskScreen(task: task),
                          ),
                        );
                      },
                      backgroundColor: AppTheme.primary,
                      foregroundColor: AppTheme.white,
                      icon: Icons.edit,
                      label: AppLocalizations.of(context)!.edit,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ]
                ],
              )
            : null,

        /* -------------------------------------------------------------------------- */
        /*                            Task Content Container                           */
        /* -------------------------------------------------------------------------- */
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppTheme.backgroundDark : AppTheme.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 62,
                width: 4,
                margin: const EdgeInsetsDirectional.only(
                    start: 15, top: 15, bottom: 15),
                decoration: BoxDecoration(
                  color: task.isDone ? AppTheme.green : AppTheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        task.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: task.isDone
                              ? AppTheme.green
                              : (isDark ? AppTheme.white : AppTheme.primary),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.description,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: task.isDone
                              ? AppTheme.green
                              : (isDark ? AppTheme.white : AppTheme.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () async {
                    try {
                      final currentUser = FirebaseAuth.instance.currentUser;
                      if (currentUser == null) {
                        throw Exception('No user logged in');
                      }

                      final String userId =
                          Provider.of<SettingsProvider>(context, listen: false)
                              .userId;
                      final String finalUserId =
                          userId.isEmpty ? currentUser.uid : userId;

                      final bool newIsDone = !task.isDone;
                      final TaskModel updatedTask = TaskModel(
                        id: task.id,
                        title: task.title,
                        description: task.description,
                        date: task.date,
                        isDone: newIsDone,
                      );

                      // Update in Firebase first
                      await FirebaseFunctions.updateTaskInFirestore(
                          updatedTask, finalUserId);

                      // Force refresh tasks after update
                      await Provider.of<TasksProvider>(context, listen: false)
                          .getTasks(finalUserId);

                      if (updatedTask.isDone) {
                        Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)!.undoDoneMessage,
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: AppTheme.green,
                          textColor: AppTheme.white,
                        );
                      }
                    } catch (e) {
                      Fluttertoast.showToast(
                        msg: e.toString().contains('No user logged in')
                            ? 'Please login to update tasks'
                            : 'Failed to update task status',
                        toastLength: Toast.LENGTH_LONG,
                        backgroundColor: AppTheme.red,
                        textColor: AppTheme.white,
                      );
                    }
                  },
                  child: task.isDone
                      ? Center(
                          child: Text(
                            AppLocalizations.of(context)!.done,
                            style: const TextStyle(
                              color: AppTheme.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        )
                      : Container(
                          height: 34,
                          width: 69,
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 32,
                            color: AppTheme.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
