import 'package:crosscheck/features/task/domain/entities/task_entity.dart';
import 'package:equatable/equatable.dart';

class TaskModel extends Equatable {
  
  final String id;
  final String title;
  final String description;
  final String startDate;
  final String startTime;
  final String endDate;
  final String endTime;
  final bool isAllDay;
  final List<DateTime> alerts;
  final String status;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.isAllDay,
    required this.alerts,
    required this.status
  });

  factory TaskModel.fromTaskEntity(TaskEntity entity) {
    String startDate = "${entity.start.day.toString().padLeft(2, "0")}-${entity.start.month.toString().padLeft(2, "0")}-${entity.start.year}";
    String startTime = "${entity.start.hour.toString().padLeft(2, "0")}:${entity.start.minute.toString().padLeft(2, "0")}";
    String endDate = "${entity.end.day.toString().padLeft(2, "0")}-${entity.end.month.toString().padLeft(2, "0")}-${entity.end.year}";
    String endTime = "${entity.start.hour.toString().padLeft(2, "0")}:${entity.start.minute.toString().padLeft(2, "0")}";
    
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      startDate: startDate,
      startTime: startTime,
      endDate: endDate,
      endTime: endTime,
      isAllDay: entity.isAllDay,
      alerts: entity.alerts,
      status: entity.start.isBefore(DateTime.now()) ? "Completed" : "Active"
    );
  }

  TaskModel copyWith(
    String? id,
    String? title,
    String? description,
    DateTime? start,
    DateTime? end,
    bool? isAllDay,
    List<DateTime>? alerts,
    String? status
  ) {
    String startDate = "${start?.day.toString().padLeft(2, "0")}-${start?.month.toString().padLeft(2, "0")}-${start?.year}";
    String startTime = "${start?.hour.toString().padLeft(2, "0")}:${start?.minute.toString().padLeft(2, "0")}";
    String endDate = "${end?.day.toString().padLeft(2, "0")}-${end?.month.toString().padLeft(2, "0")}-${end?.year}";
    String endTime = "${end?.hour.toString().padLeft(2, "0")}:${end?.minute.toString().padLeft(2, "0")}";

    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: (start == null) ? this.startDate : startDate,
      startTime: (start == null) ? this.startTime : startTime,
      endDate: (end == null) ? this.endDate : endDate,
      endTime: (end == null) ? this.endTime : endTime,
      isAllDay: isAllDay ?? this.isAllDay,
      alerts: alerts ?? this.alerts,
      status: status ?? this.status
    );
  }

  @override
  List<Object?> get props => [
    id, title, description, startDate, startTime, endDate, endTime, isAllDay, alerts, status
  ];

}