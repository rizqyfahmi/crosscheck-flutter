import 'package:crosscheck/features/task/presentation/bloc/monthly_task_model.dart';
import 'package:crosscheck/features/task/presentation/bloc/task_model.dart';
import 'package:equatable/equatable.dart';

abstract class TaskState extends Equatable {
  final List<TaskModel> models;
  final List<MonthlyTaskModel> monthlyTaskModels;

  const TaskState({
    required this.models,
    required this.monthlyTaskModels
  });
  
  @override
  List<Object?> get props => [models, monthlyTaskModels];
}

class TaskInit extends TaskState {
  TaskInit() : super(models: [], monthlyTaskModels: []);
}

class TaskLoading extends TaskState {
  const TaskLoading({required super.models, required super.monthlyTaskModels});
}

class TaskLoaded extends TaskState {
  const TaskLoaded({required super.models, required super.monthlyTaskModels});
}

class TaskIdle extends TaskState {
  const TaskIdle({required super.models, required super.monthlyTaskModels});
}

class TaskGeneralError extends TaskState {
  final String? title;
  final String message;

  const TaskGeneralError({required super.models, required super.monthlyTaskModels, required this.message, this.title});

  @override
  List<Object?> get props => [models, monthlyTaskModels, title, message];

}