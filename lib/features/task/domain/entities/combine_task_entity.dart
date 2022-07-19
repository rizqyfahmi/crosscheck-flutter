import 'package:crosscheck/features/task/domain/entities/monthly_task_entity.dart';
import 'package:crosscheck/features/task/domain/entities/task_entity.dart';
import 'package:equatable/equatable.dart';

class CombineTaskEntity extends Equatable {

  final MonthlyTaskEntity monthly;
  final List<TaskEntity> tasks;

  const CombineTaskEntity({
    required this.monthly,
    required this.tasks
  });

  @override
  List<Object?> get props => [monthly, tasks];

}