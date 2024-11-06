// ignore_for_file: avoid_print

/* -------------------------------------------------------------------------- */
/*                            Tasks Provider Class                              */
/* -------------------------------------------------------------------------- */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/firebase_functions.dart';

class TasksProvider extends ChangeNotifier {
  /* -------------------------------------------------------------------------- */
  /*                              State Variables                                 */
  /* -------------------------------------------------------------------------- */
  List<TaskModel> tasks = [];
  DateTime selectedDate = DateTime.now();
  String userId = '';

  /* -------------------------------------------------------------------------- */
  /*                              Task Management                                 */
  /* -------------------------------------------------------------------------- */
  Future<void> getTasks(String userId) async {
    try {
      // Normalize the selected date to midnight for comparison
      DateTime normalizedSelectedDate = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );

      print('Fetching tasks for date: $normalizedSelectedDate'); // Debug log

      CollectionReference<TaskModel> tasksCollection =
          FirebaseFunctions.getTasksCollection(userId);

      // Get all tasks and filter in memory to ensure proper date comparison
      QuerySnapshot<TaskModel> querySnapshot = await tasksCollection.get();

      tasks = querySnapshot.docs.map((doc) {
        TaskModel task = doc.data();
        task.id = doc.id;
        return task;
      }).where((task) {
        DateTime taskDate = DateTime(
          task.date.year,
          task.date.month,
          task.date.day,
        );
        return taskDate.isAtSameMomentAs(normalizedSelectedDate);
      }).toList();

      print('Found ${tasks.length} tasks'); // Debug log
      notifyListeners();
    } catch (e) {
      print('Error fetching tasks: $e');
      rethrow;
    }
  }

  Future<void> addTask(TaskModel task) async {
    try {
      if (userId.isEmpty) {
        throw Exception('User ID not set');
      }

      // First add to Firebase
      await FirebaseFunctions.addTaskToFirestore(task, userId);

      // Only add to local list if the task date matches selected date
      if (isSameDay(task.date, selectedDate)) {
        tasks.add(task);
        notifyListeners();
      }

      // Refresh the tasks list to ensure consistency
      await getTasks(userId);
    } catch (e) {
      print('Error adding task: $e');
      rethrow;
    }
  }

  void updateTask(TaskModel task) {
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      notifyListeners();
    }
  }

  void changeSelectedDate(DateTime date, String userId) async {
    selectedDate = date;
    notifyListeners();
    getTasks(userId);
  }

  void setUserId(String id) {
    userId = id;
    notifyListeners();
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
