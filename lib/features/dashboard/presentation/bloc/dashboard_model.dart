import 'package:crosscheck/features/dashboard/presentation/bloc/activity_model.dart';
import 'package:equatable/equatable.dart';

class DashboardModel extends Equatable {
  
  final String username;
  final String photoPath;
  final String taskText;
  final int upcoming;
  final int completed;
  final String progress;
  late final List<ActivityModel> activities;

  DashboardModel({
    this.username = "N/A",
    this.photoPath = "",  
    this.taskText = "You have no task right now",
    this.upcoming = 0,
    this.completed = 0,
    this.progress = "0%",
    List<ActivityModel> activities = const []
  }) {
    final currentDateTime = DateTime.now();
    final currentDate = DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day);
    this.activities = activities.isEmpty ? [
      ActivityModel(date: currentDate..subtract(Duration(days: currentDate.weekday - DateTime.monday))),
      ActivityModel(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.tuesday))),
      ActivityModel(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.wednesday))),
      ActivityModel(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.thursday))),
      ActivityModel(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.friday))),
      ActivityModel(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.saturday))),
      ActivityModel(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.sunday))),
    ] : activities;
  }

  DashboardModel copyWith({
    String? username,
    String? photoPath,
    String? taskText,
    int? upcoming,
    int? completed,
    String? progress,
    List<ActivityModel>? activities
  }) {
    return DashboardModel(
      username: username ?? this.username, 
      photoPath: photoPath ?? this.photoPath, 
      taskText: taskText ?? this.taskText, 
      upcoming: upcoming ?? this.upcoming, 
      completed: completed ?? this.completed, 
      progress: progress ?? this.progress, 
      activities: activities ?? this.activities
    );
  }

  @override
  List<Object?> get props => [
    username, photoPath, taskText, upcoming, completed, progress, activities
  ];
  
}