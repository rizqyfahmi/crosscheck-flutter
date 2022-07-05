import 'package:crosscheck/features/task/domain/entities/task_entity.dart';
import 'package:equatable/equatable.dart';

class TaskModel extends Equatable {
  
  final String id;
  final String title;
  final String description;
  final DateTime start;
  final DateTime end;
  final bool isAllDay;
  final List<DateTime> alerts;
  final String status;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.start,
    required this.end,
    required this.isAllDay,
    required this.alerts,
    required this.status
  });

  factory TaskModel.fromTaskEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      start: entity.start,
      end: entity.end,
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
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      start: start ?? this.start,
      end: end ?? this.end,
      isAllDay: isAllDay ?? this.isAllDay,
      alerts: alerts ?? this.alerts,
      status: status ?? this.status
    );
  }

  @override
  List<Object?> get props => [
    id, title, description, start, end, isAllDay, alerts, status
  ];

}