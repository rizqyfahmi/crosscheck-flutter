import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {

  final String id;
  final String title;
  final String description;
  final DateTime start;
  final DateTime end;
  final bool isAllDay;
  final List<DateTime> alerts;

  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.start,
    required this.end,
    required this.isAllDay,
    required this.alerts
  });

  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? start,
    DateTime? end,
    bool? isAllDay,
    List<DateTime>? alerts
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title, 
      description: description ?? this.description, 
      start: start ?? this.start,
      end: end ?? this.end, 
      isAllDay: isAllDay ?? this.isAllDay,
      alerts: alerts ?? this.alerts
    );
  }

  @override
  List<Object?> get props => [
    id, title, description, start, end, isAllDay, alerts
  ];

}