/* -------------------------------------------------------------------------- */
/*                            Required Imports                                  */
/* -------------------------------------------------------------------------- */
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/firebase_functions.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/tabs/settings/settings_provider.dart';
import 'package:todo_app/tabs/tasks/tasks_provider.dart';
import 'package:todo_app/widgets/default_elevated_button.dart';
import 'package:todo_app/widgets/default_text_form_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/* -------------------------------------------------------------------------- */
/*                            Add Task Bottom Sheet Widget                      */
/* -------------------------------------------------------------------------- */
class AddTasksBottomSheet extends StatefulWidget {
  const AddTasksBottomSheet({super.key});

  @override
  State<AddTasksBottomSheet> createState() => _AddTasksBottomSheetState();
}

/* -------------------------------------------------------------------------- */
/*                            Bottom Sheet State                                */
/* -------------------------------------------------------------------------- */
class _AddTasksBottomSheetState extends State<AddTasksBottomSheet> {
  /* -------------------------------------------------------------------------- */
  /*                            Form Controllers & Variables                      */
  /* -------------------------------------------------------------------------- */
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    /* -------------------------------------------------------------------------- */
    /*                            Theme & Style Variables                          */
    /* -------------------------------------------------------------------------- */
    TextStyle? titleMediumStyle = Theme.of(context).textTheme.titleMedium;
    bool isDark = Provider.of<SettingsProvider>(context).isDark;

    /* -------------------------------------------------------------------------- */
    /*                            Main Bottom Sheet Layout                         */
    /* -------------------------------------------------------------------------- */
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(15),
            right: Radius.circular(15),
          ),
          color: isDark ? AppTheme.backgroundDark : AppTheme.white,
        ),
        /* -------------------------------------------------------------------------- */
        /*                            Form Content                                     */
        /* -------------------------------------------------------------------------- */
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /* -------------------------------------------------------------------------- */
                /*                            Title Section                                    */
                /* -------------------------------------------------------------------------- */
                Text(
                  AppLocalizations.of(context)!.addNewTask,
                  style: titleMediumStyle?.copyWith(
                    color: isDark ? AppTheme.white : AppTheme.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                /* -------------------------------------------------------------------------- */
                /*                            Task Title Input                                 */
                /* -------------------------------------------------------------------------- */
                DefaultTextFormField(
                  controller: titleController,
                  hintText: AppLocalizations.of(context)!.enterTaskTitle,
                  isDark: isDark,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(context)!.titleCannotBeEmpty;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                /* -------------------------------------------------------------------------- */
                /*                            Task Description Input                           */
                /* -------------------------------------------------------------------------- */
                DefaultTextFormField(
                  controller: descriptionController,
                  hintText: AppLocalizations.of(context)!.enterTaskDescription,
                  isDark: isDark,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(context)!
                          .descriptionCannotBeEmpty;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                /* -------------------------------------------------------------------------- */
                /*                            Date Selection Section                           */
                /* -------------------------------------------------------------------------- */
                Text(
                  AppLocalizations.of(context)!.selectDate,
                  style: titleMediumStyle?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppTheme.white : AppTheme.black,
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () async {
                    DateTime? dateTime = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                    );
                    if (dateTime != null && selectedDate != dateTime) {
                      setState(() {
                        selectedDate = dateTime;
                      });
                    }
                  },
                  child: Text(
                    dateFormat.format(selectedDate),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark ? AppTheme.white : AppTheme.black,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                /* -------------------------------------------------------------------------- */
                /*                            Save Button Section                              */
                /* -------------------------------------------------------------------------- */
                DefaultElevatedButton(
                  label: AppLocalizations.of(context)!.save,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      addTask();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                            Task Addition Method                              */
  /* -------------------------------------------------------------------------- */
  void addTask() {
    TaskModel task = TaskModel(
      title: titleController.text,
      description: descriptionController.text,
      date: selectedDate,
    );

    /* -------------------------------------------------------------------------- */
    /*                            Firebase Task Addition                           */
    /* -------------------------------------------------------------------------- */
    FirebaseFunctions.addTaskToFirestore(task)
        /* -------------------------------------------------------------------------- */
        /*                            Success Handler                                  */
        /* -------------------------------------------------------------------------- */
        .timeout(
      const Duration(),
      onTimeout: () {
        Navigator.of(context).pop();
        Provider.of<TasksProvider>(context, listen: false).getTasks();
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.taskAdded,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      },
    )
        /* -------------------------------------------------------------------------- */
        /*                            Error Handler                                    */
        /* -------------------------------------------------------------------------- */
        .catchError(
      (error) {
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.somethingWentWrong,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      },
    );
  }
}
