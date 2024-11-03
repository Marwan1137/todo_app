import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/firebase_functions.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/tabs/tasks/tasks_provider.dart';
import 'package:todo_app/tabs/tasks/update_task_screen.dart';

// ignore: must_be_immutable
class TaskItem extends StatelessWidget {
  TaskItem(this.task, {super.key});
  TaskModel task;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 20,
      ),
      child: Slidable(
        startActionPane: ActionPane(
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
                    .catchError(
                  (_) {
                    Fluttertoast.showToast(
                      msg: "Task deleted successfully",
                      toastLength: Toast
                          .LENGTH_LONG, // long ya3ni hayezhar le modet 5 seconds w lo short hayo3od 2 seconds //
                      // gravity: ToastGravity.CENTER, // el makan ele hayezhar feh //
                      timeInSecForIosWeb: 5,
                      backgroundColor: AppTheme.green,
                      textColor: AppTheme.white,
                      fontSize: 16.0,
                    );
                  },
                );
              },
              backgroundColor: AppTheme.red,
              foregroundColor: AppTheme.white,
              icon: Icons.delete,
              label: 'Delete',
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            const SizedBox(
              width: 5,
            ),
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
              label: 'Edit',
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
          ],
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 62,
                width: 4,
                margin: const EdgeInsetsDirectional.all(
                  15,
                ),
                decoration: BoxDecoration(
                  color: task.isDone ? AppTheme.green : AppTheme.primary,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: task.isDone ? AppTheme.green : theme.primaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    task.description,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: task.isDone ? AppTheme.green : theme.primaryColor,
                    ),
                  ),
                ],
              ),
              const Spacer(),
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
                            msg: "If you want to undo Done!, click again on it",
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
                      ? const Center(
                          child: Text(
                            'Done!',
                            style: TextStyle(
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
                            color:
                                task.isDone ? Colors.green : AppTheme.primary,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
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
