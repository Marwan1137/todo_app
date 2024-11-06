import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/models/user_model.dart';

class FirebaseFunctions {
  /* -------------------------------------------------------------------------- */
  /*         ba3mel el function ele hatwady w tegib mn el FIREBASE lel Users    */
  /* -------------------------------------------------------------------------- */
  static CollectionReference<UserModel> getUsersCollection() {
    // Add error handling and logging
    try {
      return FirebaseFirestore.instance
          .collection('users')
          .withConverter<UserModel>(
            fromFirestore: (snapshot, _) {
              if (!snapshot.exists) {
                throw Exception('Document does not exist');
              }
              return UserModel.fromJson(snapshot.data() ?? {});
            },
            toFirestore: (userModel, _) => userModel.toJson(),
          );
    } catch (e) {
      print('Error in getUsersCollection: $e');
      rethrow;
    }
  }

  /* -------------------------------------------------------------------------- */
  /*         ba3mel el function ele hatwady w tegib mn el FIREBASE lel Tasks    */
  /* -------------------------------------------------------------------------- */
  static CollectionReference<TaskModel> getTasksCollection(String userId) =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('tasks')
          .withConverter<TaskModel>(
            fromFirestore: (snapshot, _) =>
                TaskModel.fromJson(snapshot.data() ?? {}, snapshot.id),
            toFirestore: (taskModel, _) => taskModel.toJson(),
          );

  /* ------------------------------------------------------------------------------------- */
  /*   el function ele ba3mel feha *CREATE* lel TASK w a3mel el add leh fe el *FIRESTORE*  */
  /* ------------------------------------------------------------------------------------- */
  static Future<void> addTaskToFirestore(TaskModel task, String userId) {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection(userId);
    DocumentReference<TaskModel> doc =
        tasksCollection.doc(); //lma bab3atha fadya beye3mel auto generated ID//
    task.id = doc
        .id; // bakhaly el ID beta3 el TASK yakhod el ID el GENERATED mn el .doc() //
    return doc.set(task); //betemla el data ele gowa el file//
  }
  /* -------------------------------------------------------------------------- */

  /* -------------------------------------------------------------------------- */
  /*            ba3mel retrieve(READ) lel Added TASK ele 3amaltha     */
  /* -------------------------------------------------------------------------- */
  static Future<List<TaskModel>> getAllTasksFromFirestore(String userId) async {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection(userId);
    QuerySnapshot<TaskModel> querySnapshot = await tasksCollection.get();
    return querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }
  /* -------------------------------------------------------------------------- */

  /* -------------------------------------------------------------------------- */
  /*        ba3mel delete lel task mn firebase (Delete Function)                */
  /* -------------------------------------------------------------------------- */
  static Future<void> deleteTaskFromFirestore(
      String taskId, String userId) async {
    CollectionReference<TaskModel> taskCollection = getTasksCollection(userId);
    return taskCollection.doc(taskId).delete();
  }
  /* -------------------------------------------------------------------------- */

  /* -------------------------------------------------------------------------- */
  /*        ba3mel update lel task mn firebase (Update Function)                */
  /* -------------------------------------------------------------------------- */
  static Future<void> updateTaskInFirestore(
      TaskModel task, String userId) async {
    try {
      if (task.id.isEmpty) {
        print('Debug: Task ID is empty'); // Debug log
        throw Exception('Task ID is missing');
      }

      print(
          'Debug: Updating task - ID: ${task.id}, isDone: ${task.isDone}'); // Debug log

      // Get the specific document reference
      final DocumentReference<TaskModel> taskDoc =
          getTasksCollection(userId).doc(task.id);

      // Convert task to map for update
      final Map<String, dynamic> updates = {
        'id': task.id,
        'title': task.title,
        'description': task.description,
        'date': task.date,
        'isDone': task.isDone,
      };

      print('Debug: Update data: $updates'); // Debug log

      // Use update instead of set
      return await taskDoc.update(updates);
    } catch (e) {
      print('Error updating task: $e'); // For debugging
      throw Exception('Failed to update task: $e');
    }
  }
  /* -------------------------------------------------------------------------- */

  /* -------------------------------------------------------------------------- */
  /*        ba3mel register lel user mn firebase (Register Function)            */
  /* -------------------------------------------------------------------------- */
  static Future<UserModel> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Create user in Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user == null) {
        throw Exception('User creation failed');
      }

      // Create UserModel
      UserModel userModel = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
      );

      // Save user data to Firestore
      await getUsersCollection().doc(userModel.id).set(userModel);

      return userModel;
    } catch (e) {
      print('Error in registerUser: $e');
      rethrow;
    }
  }
  /* -------------------------------------------------------------------------- */

  /* -------------------------------------------------------------------------- */
  /*        ba3mel login lel user mn firebase (Login Function)                  */
  /* -------------------------------------------------------------------------- */
  static Future<UserModel> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in with Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user == null) {
        throw Exception('Authentication failed');
      }

      // Get user document from Firestore
      DocumentSnapshot<UserModel> userDoc =
          await getUsersCollection().doc(userCredential.user!.uid).get();

      if (!userDoc.exists) {
        throw Exception('User document not found');
      }

      UserModel? userData = userDoc.data();
      if (userData == null) {
        throw Exception('User data is null');
      }

      return userData;
    } catch (e) {
      print('Error in loginUser: $e');
      rethrow;
    }
  }
  /* -------------------------------------------------------------------------- */

  /* -------------------------------------------------------------------------- */
  /*        ba3mel logout lel user mn firebase (Logout Function)                */
  /* -------------------------------------------------------------------------- */
  static Future<void> logoutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Error in logoutUser: $e');
      rethrow;
    }
  }
  /* -------------------------------------------------------------------------- */
}
