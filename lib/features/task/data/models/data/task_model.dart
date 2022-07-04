import 'package:crosscheck/features/task/domain/entities/task_entity.dart';
import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class TaskModel extends TaskEntity {

  @override
  @HiveField(0)
  String get id => super.id;

  @override
  @HiveField(1)
  String get title => super.title;

  @override
  @HiveField(2)
  String get description => super.description;

  @override
  @HiveField(3)
  DateTime get start => super.start;

  @override
  @HiveField(4)
  DateTime get end => super.end;

  @override
  @HiveField(5)
  bool get isAllDay => super.isAllDay;

  @override
  @HiveField(6)
  List<DateTime> get alerts => super.alerts;
  
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