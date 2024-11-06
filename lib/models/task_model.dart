import 'package:cloud_firestore/cloud_firestore.dart';

/* -------------------------------------------------------------------------- */
/*                                Task Model                                    */
/* -------------------------------------------------------------------------- */
class TaskModel {
  String id;
  String title;
  String description;
  DateTime date;
  bool isDone;
  String userId;

  TaskModel({
    this.id = '',
    required this.title,
    required this.description,
    required this.date,
    this.isDone = false,
    this.userId = '',
  });

  /* -------------------------------------------------------------------------- */
  /*                              From JSON Method                                */
  /* -------------------------------------------------------------------------- */
  TaskModel.fromJson(Map<String, dynamic> json, String id)
      : this(
          id: json['id'] ?? '',
          title: json['title'] ?? '',
          description: json['description'] ?? '',
          date: (json['date'] as Timestamp).toDate(),
          isDone: json['isDone'] ?? false,
          userId: json['userId'] ?? '',
        );

  /* -------------------------------------------------------------------------- */
  /*                               To JSON Method                                 */
  /* -------------------------------------------------------------------------- */
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'date': Timestamp.fromDate(date),
        'isDone': isDone,
        'userId': userId,
      };
}
