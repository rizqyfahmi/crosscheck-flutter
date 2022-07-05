import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/features/task/domain/entities/task_entity.dart';
import 'package:crosscheck/features/task/domain/usecases/get_history_usecase.dart';
import 'package:crosscheck/features/task/domain/usecases/get_more_history_usecase.dart';
import 'package:crosscheck/features/task/domain/usecases/get_refresh_history_usecase.dart';
import 'package:crosscheck/features/task/presentation/bloc/task_event.dart';
import 'package:crosscheck/features/task/presentation/bloc/task_model.dart';
import 'package:crosscheck/features/task/presentation/bloc/task_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef Usecase = Future<Either<Failure, List<TaskEntity>>> Function();

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetHistoryUsecase getHistoryUsecase;
  final GetMoreHistoryUsecase getMoreHistoryUsecase;
  final GetRefreshHistoryUsecase getRefreshHistoryUsecase;

  TaskBloc(super.initialState, {required this.getHistoryUsecase, required this.getMoreHistoryUsecase, required this.getRefreshHistoryUsecase});

}