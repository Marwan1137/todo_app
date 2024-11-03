import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/task_model.dart';

class FirebaseFunctions {
  /* -------------------------------------------------------------------------- */
  /*         ba3mel el function ele hatwady w tegib mn el FIREBASE         */
  /* -------------------------------------------------------------------------- */
  static CollectionReference<TaskModel> getTasksCollection() =>
      FirebaseFirestore.instance.collection('tasks').withConverter<TaskModel>(
            fromFirestore: (snapshot, _) =>
                TaskModel.fromJson(snapshot.data()!),
            toFirestore: (taskModel, _) => taskModel.toJson(),
          );
  /* -------------------------------------------------------------------------- */

  /* -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- */
  /*                                                         el function ele ba3mel feha *CREATE* lel TASK w a3mel el add leh fe el *FIRESTORE*                                                         */
  /* -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- */
  static Future<void> addTaskToFirestore(TaskModel task) {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection();
    DocumentReference<TaskModel> doc =
        tasksCollection.doc(); //lma bab3atha fadya beye3mel auto generated ID//
    task.id = doc
        .id; // bakhaly el ID beta3 el TASK yakhod el ID el GENERATED mn el .doc() //
    return doc.set(task); //betemla el data ele gowa el file//
  }
  /* -------------------------------------------------------------------------- */

  /* ---------------------------------------------------------------- */
  /*            ba3mel retrieve(READ) lel Added TASK ele 3amaltha     */
  /* ---------------------------------------------------------------- */
  static Future<List<TaskModel>> getAllTasksFromFirestore() async {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection();
    QuerySnapshot<TaskModel> querySnapshot = await tasksCollection.get();
    return querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }
  /* ---------------------------------------------------------------------------------------------- */
}