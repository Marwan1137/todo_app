import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/firebase_functions.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/tabs/tasks/tasks_provider.dart';

// ignore: must_be_immutable
class TaskItem extends StatelessWidget {
  TaskItem(this.task, {super.key});
  TaskModel task;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(
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
                  Duration(microseconds: 100),
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
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
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
                horizontal: 25,
              ),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
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
                margin: EdgeInsetsDirectional.all(
                  15,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.all(
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
                      color: theme.primaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    task.description,
                    style: theme.textTheme.titleSmall,
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 34,
                  width: 69,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Icon(
                    Icons.check,
                    size: 32,
                    color: AppTheme.white,
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
