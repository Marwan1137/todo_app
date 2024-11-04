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
                    onPressed: (_) {
                      FirebaseFunctions.deleteTaskFromFirestore(task.id)
                          .timeout(
                        const Duration(microseconds: 100),
                        onTimeout: () =>
                            Provider.of<TasksProvider>(context, listen: false)
                                .getTasks(),
                      )
                          .catchError((_) {
                        Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)!.taskDeleted,
                          toastLength: Toast.LENGTH_LONG,
                          timeInSecForIosWeb: 5,
                          backgroundColor: AppTheme.green,
                          textColor: AppTheme.white,
                          fontSize: 16.0,
                        );
                      });
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
                        vertical: 10,
                        horizontal: 10,
                      ),
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
                    onPressed: (_) {
                      FirebaseFunctions.deleteTaskFromFirestore(task.id)
                          .timeout(
                        const Duration(microseconds: 100),
                        onTimeout: () =>
                            Provider.of<TasksProvider>(context, listen: false)
                                .getTasks(),
                      )
                          .catchError((_) {
                        Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)!.taskDeleted,
                          toastLength: Toast.LENGTH_LONG,
                          timeInSecForIosWeb: 5,
                          backgroundColor: AppTheme.green,
                          textColor: AppTheme.white,
                          fontSize: 16.0,
                        );
                      });
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
              /* -------------------------------------------------------------------------- */
              /*                            Task Status Indicator                            */
              /* -------------------------------------------------------------------------- */
              Container(
                height: 62,
                width: 4,
                margin: const EdgeInsetsDirectional.only(
                  start: 15,
                  top: 15,
                  bottom: 15,
                ),
                decoration: BoxDecoration(
                  color: task.isDone ? AppTheme.green : AppTheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              /* -------------------------------------------------------------------------- */
              /*                            Task Details Section                             */
              /* -------------------------------------------------------------------------- */
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

              /* -------------------------------------------------------------------------- */
              /*                            Task Status Toggle Button                        */
              /* -------------------------------------------------------------------------- */
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () {
                    task.isDone = !task.isDone;
                    FirebaseFunctions.updateTaskInFirestore(task).timeout(
                      const Duration(microseconds: 100),
                      onTimeout: () {
                        Provider.of<TasksProvider>(context, listen: false)
                            .updateTask(task);

                        if (task.isDone) {
                          Fluttertoast.showToast(
                            msg: AppLocalizations.of(context)!.undoDoneMessage,
                            toastLength: Toast.LENGTH_LONG,
                            timeInSecForIosWeb: 5,
                            backgroundColor: AppTheme.green,
                            textColor: AppTheme.white,
                            fontSize: 15.0,
                          );
                        }
                      },
                    );
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
