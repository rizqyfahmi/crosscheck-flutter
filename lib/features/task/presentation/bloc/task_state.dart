import 'package:crosscheck/features/task/presentation/bloc/task_model.dart';
import 'package:equatable/equatable.dart';

abstract class TaskState extends Equatable {
  final List<TaskModel> models;

  const TaskState({
    required this.models
  });
  
  @override
  List<Object?> get props => [models];
}

class TaskInit extends TaskState {
  TaskInit() : super(models: []);
}

class TaskLoading extends TaskState {
  const TaskLoading({required super.models});
}

class TaskLoaded extends TaskState {
  const TaskLoaded({required super.models});
}

class TaskIdle extends TaskState {
  const TaskIdle({required super.models});
}

class TaskGeneralError extends TaskState {
  final String? title;
  final String message;

  const TaskGeneralError({required super.models, required this.message, this.title});

  @override
  List<Object?> get props => [models, title, message];

}