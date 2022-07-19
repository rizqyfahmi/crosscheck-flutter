import 'package:crosscheck/features/task/domain/entities/monthly_task_entity.dart';
import 'package:crosscheck/features/task/domain/entities/task_entity.dart';
import 'package:equatable/equatable.dart';

class CombineTaskEntity extends Equatable {

  final List<MonthlyTaskEntity> monthlyTaskEntities;
  final List<TaskEntity> taskEntities;

  const CombineTaskEntity({
    required this.monthlyTaskEntities,
    required this.taskEntities
  });

  @override
  List<Object?> get props => [monthlyTaskEntities, taskEntities];

}