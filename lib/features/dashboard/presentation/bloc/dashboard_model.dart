import 'package:crosscheck/features/dashboard/presentation/bloc/activity_model.dart';
import 'package:equatable/equatable.dart';

class DashboardModel extends Equatable {
  
  final String username;
  final String photoPath;
  final String taskText;
  final int upcoming;
  final int completed;
  final double progress;
  final List<ActivityModel> activities;

  const DashboardModel({
    this.username = "",
    this.photoPath = "",
    this.taskText = "",
    this.upcoming = 0,
    this.completed = 0,
    this.progress = 0,
    this.activities = const []
  });

  DashboardModel copyWith({
    String? username,
    String? photoPath,
    String? taskText,
    int? upcoming,
    int? completed,
    double? progress,
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