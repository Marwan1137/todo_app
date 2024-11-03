import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/firebase_functions.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/tabs/tasks/tasks_provider.dart';
import 'package:todo_app/widgets/default_elevated_button.dart';
import 'package:todo_app/widgets/default_text_form_field.dart';

class AddTasksBottomSheet extends StatefulWidget {
  const AddTasksBottomSheet({super.key});

  @override
  State<AddTasksBottomSheet> createState() => _AddTasksBottomSheetState();
}

class _AddTasksBottomSheetState extends State<AddTasksBottomSheet> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextStyle? titleMediumStyle = Theme.of(context).textTheme.titleMedium;

    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.sizeOf(context).height * 0.5,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Text(
              'Add new Task',
              style: titleMediumStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            DefaultTextFormField(
              controller: titleController,
              hintText: 'Enter Task Title',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Title can not be empty';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            DefaultTextFormField(
              controller: descriptionController,
              hintText: 'Enter Task Descriptiom',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Description can not be empty';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'Select Date',
              style: titleMediumStyle?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 10,
            ),
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
                  selectedDate = dateTime;
                }
                setState(() {});
              },
              child: Text(
                dateFormat.format(selectedDate),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            DefaultElevatedButton(
              label: 'Add',
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  addTask();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void addTask() {
    // ignore: unused_local_variable
    TaskModel task = TaskModel(
      title: titleController.text,
      description: descriptionController.text,
      date: selectedDate,
    );
    FirebaseFunctions.addTaskToFirestore(task)
        /* ---------------------------------------------------------------- */
        /*                   ye3mel eh fe halet el success                  */
        /* ---------------------------------------------------------------- */
        .timeout(
      Duration(),
      onTimeout: () {
        Navigator.of(context).pop();
        /* ---------------------------------------------------------------------------------------------- */
        /*               kda ana b-access el method bas mesh 3aiez a3mel LISTEN 3la data feh              */
        /* ---------------------------------------------------------------------------------------------- */
        Provider.of<TasksProvider>(context, listen: false).getTasks();
      },
    )
        /* ---------------------------------------------------------------- */
        /*                  betetnededh lma yeb2a feh error                 */
        /* ---------------------------------------------------------------- */
        .catchError(
      (error) {
        print(error);
      },
    );
  }
}
