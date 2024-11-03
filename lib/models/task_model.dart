import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TaskModel {
  String id;
  String title;
  String description;
  DateTime date;
  bool isDone;
  TaskModel({
    this.id = '',
    required this.title,
    required this.description,
    required this.date,
    this.isDone = false,
  });

  /* -------------------------------------------------------------------------- */
  /*                              from JSON method                              */
  /* -------------------------------------------------------------------------- */
  TaskModel.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          title: json['title'],
          description: json['description'],
          date: (json['date'] as Timestamp).toDate(),
          isDone: json['isDone'],
        );
  /* -------------------------------------------------------------------------- */
  /*                               To JSON method                               */
  /* -------------------------------------------------------------------------- */
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'date': Timestamp.fromDate(date),
        'isDone': isDone,
      };
}
