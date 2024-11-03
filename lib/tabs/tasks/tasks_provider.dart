import 'package:flutter/material.dart';
import 'package:todo_app/firebase_functions.dart';
import 'package:todo_app/models/task_model.dart';

class TasksProvider with ChangeNotifier {
  List<TaskModel> tasks = [];
  DateTime selectedDate = DateTime.now();

  Future<void> getTasks() async {
    tasks = await FirebaseFunctions.getAllTasksFromFirestore();
    tasks = tasks
        .where(
          (task) =>
              task.date.year == selectedDate.year &&
              task.date.day == selectedDate.day &&
              task.date.month == selectedDate.month,
        )
        .toList();
    notifyListeners();
  }

  void changeSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }
}
