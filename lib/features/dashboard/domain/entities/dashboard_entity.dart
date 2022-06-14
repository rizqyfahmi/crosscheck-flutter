import 'package:crosscheck/features/dashboard/domain/entities/activity_entity.dart';
import 'package:equatable/equatable.dart';

class DashboardEntity extends Equatable {

  final double progress;
  final int upcoming;
  final int completed;
  final List<ActivityEntity> activities;
  
  const DashboardEntity({
    required this.progress,
    required this.upcoming,
    required this.completed,
    required this.activities
  });

  DashboardEntity copyWith({
    double? progress,
    int? upcoming,
    int? completed,
    List<ActivityEntity>? activities
  }) {
    return DashboardEntity(
      progress: progress ?? this.progress, 
      upcoming: upcoming ?? this.upcoming, 
      completed: completed ?? this.completed, 
      activities: activities ?? this.activities
    );
  }

  @override
  List<Object?> get props => [progress, upcoming, completed, activities];
  
}