/* -------------------------------------------------------------------------- */
/*                            Required Imports                                  */
/* -------------------------------------------------------------------------- */
// ignore_for_file: no_logic_in_create_state, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/firebase_functions.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/tabs/settings/settings_provider.dart';
import 'package:todo_app/tabs/tasks/tasks_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/* -------------------------------------------------------------------------- */
/*                            Update Task Screen Widget                         */
/* -------------------------------------------------------------------------- */
class UpdateTaskScreen extends StatefulWidget {
  final TaskModel task;

  const UpdateTaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  UpdateTaskScreenState createState() => UpdateTaskScreenState(task);
}

/* -------------------------------------------------------------------------- */
/*                            Update Task Screen State                          */
/* -------------------------------------------------------------------------- */
class UpdateTaskScreenState extends State<UpdateTaskScreen> {
  /* -------------------------------------------------------------------------- */
  /*                            Form Variables & Controllers                      */
  /* -------------------------------------------------------------------------- */
  final formKey = GlobalKey<FormState>();
  late String title;
  late String description;
  late DateTime date;

  /* -------------------------------------------------------------------------- */
  /*                            Constructor                                       */
  /* -------------------------------------------------------------------------- */
  UpdateTaskScreenState(TaskModel task) {
    title = task.title;
    description = task.description;
    date = task.date;
  }

  /* -------------------------------------------------------------------------- */
  /*                            Update Task Method                               */
  /* -------------------------------------------------------------------------- */
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
            msg: AppLocalizations.of(context)!.taskUpdated,
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
    /* -------------------------------------------------------------------------- */
    /*                            Screen Variables                                 */
    /* -------------------------------------------------------------------------- */
    double screenHeight = MediaQuery.of(context).size.height;
    bool isDark = Provider.of<SettingsProvider>(context).isDark;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          /* -------------------------------------------------------------------------- */
          /*                            App Bar Section                                  */
          /* -------------------------------------------------------------------------- */
          Container(
            height: screenHeight * 0.2,
            width: double.infinity,
            color: AppTheme.primary,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                top: 5.0,
                start: 20.0,
              ),
              child: Row(
                children: [
                  /* -------------------------------------------------------------------------- */
                  /*                            Back Button                                      */
                  /* -------------------------------------------------------------------------- */
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Provider.of<SettingsProvider>(context).languageCode ==
                              'ar'
                          ? Icons.arrow_forward_ios
                          : Icons.arrow_back_ios_new,
                      color: AppTheme.white,
                      size: 24,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(width: 20),
                  /* -------------------------------------------------------------------------- */
                  /*                            Screen Title                                     */
                  /* -------------------------------------------------------------------------- */
                  Text(
                    AppLocalizations.of(context)!.tasks,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Provider.of<SettingsProvider>(context).isDark
                              ? AppTheme.backgroundDark
                              : AppTheme.white,
                          fontSize: 22,
                        ),
                  ),
                ],
              ),
            ),
          ),

          /* -------------------------------------------------------------------------- */
          /*                            Main Form Container                              */
          /* -------------------------------------------------------------------------- */
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              right: 20,
              left: 20,
            ),
            child: Container(
              height: screenHeight * 0.7,
              margin:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 100.0),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.backgroundDark : AppTheme.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      /* -------------------------------------------------------------------------- */
                      /*                            Form Title                                       */
                      /* -------------------------------------------------------------------------- */
                      Text(
                        AppLocalizations.of(context)!.editTask,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppTheme.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),

                      /* -------------------------------------------------------------------------- */
                      /*                            Title Input Field                                */
                      /* -------------------------------------------------------------------------- */
                      TextFormField(
                        initialValue: title,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.taskTitle,
                          labelStyle: TextStyle(
                            color: isDark ? AppTheme.white : Colors.grey,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: isDark ? AppTheme.white : Colors.grey,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          color: isDark ? AppTheme.white : Colors.black,
                        ),
                        onChanged: (value) => title = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .titleCannotBeEmpty;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      /* -------------------------------------------------------------------------- */
                      /*                            Description Input Field                          */
                      /* -------------------------------------------------------------------------- */
                      TextFormField(
                        initialValue: description,
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.taskDescription,
                          labelStyle: TextStyle(
                            color: isDark ? AppTheme.white : Colors.grey,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: isDark ? AppTheme.white : Colors.grey,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          color: isDark ? AppTheme.white : Colors.black,
                        ),
                        onChanged: (value) => description = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .descriptionCannotBeEmpty;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      /* -------------------------------------------------------------------------- */
                      /*                            Date Picker Section                              */
                      /* -------------------------------------------------------------------------- */
                      GestureDetector(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (pickedDate != null && pickedDate != date) {
                            setState(() {
                              date = pickedDate;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.selectDate,
                            labelStyle: TextStyle(
                              color: isDark ? AppTheme.white : Colors.grey,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: isDark ? AppTheme.white : Colors.grey,
                              ),
                            ),
                          ),
                          child: Text(
                            "${date.toLocal()}".split(' ')[0],
                            style: TextStyle(
                              color: isDark ? AppTheme.white : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 120),

                      /* -------------------------------------------------------------------------- */
                      /*                            Save Button                                      */
                      /* -------------------------------------------------------------------------- */
                      ElevatedButton(
                        onPressed: updateTask,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.saveChanges,
                          style: const TextStyle(
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
