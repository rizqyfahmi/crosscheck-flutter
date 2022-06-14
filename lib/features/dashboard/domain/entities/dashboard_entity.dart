import 'package:crosscheck/features/dashboard/domain/entities/activity_entity.dart';
import 'package:equatable/equatable.dart';

class DashboardEntity extends Equatable {

  final double progress;
  final double upcoming;
  final double completed;
  final List<ActiviyEntitiy> activities;
  
  const DashboardEntity({
    required this.progress,
    required this.upcoming,
    required this.completed,
    required this.activities
  });


  @override
  List<Object?> get props => [progress, upcoming, completed, activities];
  
}