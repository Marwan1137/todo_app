import 'package:flutter/material.dart';
import 'package:todo_app/firebase_functions.dart';
import 'package:todo_app/models/task_model.dart';

/* -------------------------------------------------------------------------- */
/*                            Tasks Provider Class                              */
/* -------------------------------------------------------------------------- */
class TasksProvider with ChangeNotifier {
  List<TaskModel> tasks = [];
  DateTime selectedDate = DateTime.now();

  /* -------------------------------------------------------------------------- */
  /*                            Get Tasks From Firebase                           */
  /* -------------------------------------------------------------------------- */
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

  /* -------------------------------------------------------------------------- */
  /*                            Update Task in List                               */
  /* -------------------------------------------------------------------------- */
  void updateTask(TaskModel updatedTask) {
    final index = tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask; // Update the task in the list
      notifyListeners();
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                            Change Selected Date                              */
  /* -------------------------------------------------------------------------- */
  void changeSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }
}
