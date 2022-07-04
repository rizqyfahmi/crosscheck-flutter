import 'package:crosscheck/features/task/domain/entities/task_entity.dart';
import 'package:flutter/material.dart';

class TaskModel extends TaskEntity {
  
  const TaskModel({
    required super.id,
    required super.title, 
    required super.description, 
    required super.start, 
    required super.end, 
    required super.isAllDay, 
    required super.alerts
  });

  factory TaskModel.fromJSON(Map<String, dynamic> response) {    
    return TaskModel(
      id: response["id"],
      title: response["title"], 
      description: response["description"], 
      start: DateTime.parse(response["start"]), 
      end: DateTime.parse(response["end"]), 
      isAllDay: response["isAllDay"], 
      alerts: (response["alerts"] as List<dynamic>).map((item) => DateTime.parse(item)).toList()
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "start": start,
      "end": end,
      "isAllDay": isAllDay,
      "alerts": alerts
    };
  }
  
}