import 'package:flutter/material.dart';
import 'package:todo_app/firebase_functions.dart';
import 'package:todo_app/models/task_model.dart';

class TasksProvider with ChangeNotifier {
  List<TaskModel> tasks = [];
  Future<void> getTasks() async {
    tasks = await FirebaseFunctions.getAllTasksFromFirestore();
    notifyListeners();
  }
}
