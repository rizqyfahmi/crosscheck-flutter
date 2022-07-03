import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {

  final String title;
  final String description;
  final DateTime start;
  final DateTime end;
  final bool isAllDay;
  final List<DateTime> alerts;

  const TaskEntity({
    required this.title,
    required this.description,
    required this.start,
    required this.end,
    required this.isAllDay,
    required this.alerts
  });

  TaskEntity copyWith({
    String? title,
    String? description,
    DateTime? start,
    DateTime? end,
    bool? isAllDay,
    List<DateTime>? alerts
  }) {
    return TaskEntity(
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
    title, description, start, end, isAllDay, alerts
  ];

}