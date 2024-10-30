import 'package:flutter/material.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/models/task_model.dart';

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
    );
  }
}
