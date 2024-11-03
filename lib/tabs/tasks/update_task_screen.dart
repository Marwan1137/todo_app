// ignore_for_file: no_logic_in_create_state, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/firebase_functions.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/tabs/tasks/tasks_provider.dart';

class UpdateTaskScreen extends StatefulWidget {
  final TaskModel task;

  const UpdateTaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  UpdateTaskScreenState createState() => UpdateTaskScreenState(task);
}

class UpdateTaskScreenState extends State<UpdateTaskScreen> {
  final formKey = GlobalKey<FormState>();
  late String title;
  late String description;
  late DateTime date;

  UpdateTaskScreenState(TaskModel task) {
    title = task.title;
    description = task.description;
    date = task.date;
  }

  Future<void> updateTask() async {
    if (formKey.currentState!.validate()) {
      TaskModel updatedTask = TaskModel(
        id: widget.task.id,
        title: title,
        description: description,
        date: date,
      );

      FirebaseFunctions.updateTaskInFirestore(updatedTask).timeout(
        const Duration(milliseconds: 100),
        onTimeout: () {
          Provider.of<TasksProvider>(context, listen: false).getTasks();
          Fluttertoast.showToast(
            msg: "Task updated successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.of(context).pop();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            height: screenHeight * 0.2,
            width: double.infinity,
            color: AppTheme.primary,
            child: Padding(
              padding: const EdgeInsets.only(top: 60.0, left: 20.0),
              child: Text(
                'To Do List',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.white,
                      fontSize: 22,
                    ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              height: screenHeight * 0.7,
              margin:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 100.0),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Edit Task',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        initialValue: title,
                        decoration: const InputDecoration(
                          labelText: 'Task title',
                        ),
                        onChanged: (value) => title = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        initialValue: description,
                        decoration: const InputDecoration(
                          labelText: 'Task description',
                        ),
                        onChanged: (value) => description = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null && pickedDate != date) {
                            setState(() {
                              date = pickedDate;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Select date',
                          ),
                          child: Text(
                            "${date.toLocal()}".split(' ')[0],
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 120),
                      ElevatedButton(
                        onPressed: updateTask,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(
                            color: AppTheme.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
