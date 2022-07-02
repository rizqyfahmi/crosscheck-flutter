import 'package:crosscheck/features/dashboard/domain/entities/activity_entity.dart';
import 'package:equatable/equatable.dart';

class DashboardEntity extends Equatable {

  final double progress;
  final int upcoming;
  final int completed;
  final List<ActivityEntity> activities;
  final String? fullname;
  final String? photoUrl;
  
  const DashboardEntity({
    required this.progress,
    required this.upcoming,
    required this.completed,
    required this.activities,
    this.fullname = "",
    this.photoUrl = ""
  });

  DashboardEntity copyWith({
    double? progress,
    int? upcoming,
    int? completed,
    List<ActivityEntity>? activities,
    String? fullname,
    String? photoUrl
  }) {
    return DashboardEntity(
      progress: progress ?? this.progress, 
      upcoming: upcoming ?? this.upcoming, 
      completed: completed ?? this.completed, 
      activities: activities ?? this.activities,
      fullname: fullname ?? this.fullname,
      photoUrl: photoUrl ?? this.photoUrl
    );
  }

  @override
  List<Object?> get props => [progress, upcoming, completed, activities, fullname, photoUrl];
  
}