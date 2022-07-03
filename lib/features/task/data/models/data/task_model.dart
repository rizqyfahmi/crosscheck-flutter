import 'package:crosscheck/features/task/domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  
  const TaskModel({
    required super.title, 
    required super.description, 
    required super.start, 
    required super.end, 
    required super.isAllDay, 
    required super.alerts
  });

  factory TaskModel.fromJSON(Map<String, dynamic> response) {
    return TaskModel(
      title: response["title"], 
      description: response["description"], 
      start: response["start"], 
      end: response["end"], 
      isAllDay: response["isAllDay"], 
      alerts: response["alerts"]
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "title": title,
      "description": description,
      "start": start,
      "end": end,
      "isAllDay": isAllDay,
      "alerts": alerts
    };
  }
  
}