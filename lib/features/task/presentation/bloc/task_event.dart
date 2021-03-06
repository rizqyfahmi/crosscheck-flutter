import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  
  @override
  List<Object?> get props => [];
  
}

class TaskGetHistory extends TaskEvent {}
class TaskGetMoreHistory extends TaskEvent {}
class TaskGetRefreshHistory extends TaskEvent {}
class TaskResetGeneralError extends TaskEvent {}
class TaskGetInitialByDate extends TaskEvent {
  final DateTime time;

  TaskGetInitialByDate({
    required this.time
  });

  @override
  List<Object?> get props => [time];
}

class TaskGetMonthlyTask extends TaskEvent {
  final DateTime time;

  TaskGetMonthlyTask({
    required this.time
  });

  @override
  List<Object?> get props => [time];
}

class TaskGetByDate extends TaskEvent {
  final DateTime time;

  TaskGetByDate({
    required this.time
  });

  @override
  List<Object?> get props => [time];
}

class TaskGetMoreByDate extends TaskEvent {
  final DateTime time;

  TaskGetMoreByDate({
    required this.time
  });

  @override
  List<Object?> get props => [time];
}

class TaskGetRefreshByDate extends TaskEvent {
  final DateTime time;

  TaskGetRefreshByDate({
    required this.time
  });

  @override
  List<Object?> get props => [time];
}