import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  
  @override
  List<Object?> get props => [];
  
}

class TaskGetHistory extends TaskEvent {}
class TaskGetMoreHistory extends TaskEvent {}
class TaskGetRefreshHistory extends TaskEvent {}
class TaskResetGeneralError extends TaskEvent {}