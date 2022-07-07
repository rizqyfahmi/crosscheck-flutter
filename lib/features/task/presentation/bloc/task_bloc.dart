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

  TaskBloc({
    required this.getHistoryUsecase,
    required this.getMoreHistoryUsecase,
    required this.getRefreshHistoryUsecase
  }) : super(TaskInit()) {
    on<TaskGetHistory>((event, emit) async {
      await getHistory(event, emit, () async {
        // final entities = List<int>.generate(10, (index) => index).map((v) {
        //   final start = DateTime.parse("2022-07-03 00:00:00").add(Duration(hours: v + 1));
        //   return TaskEntity(
        //     id: v.toString(),
        //     title: "hello title $v",
        //     description: "hello description $v", 
        //     start: start, 
        //     end: start.add(const Duration(hours: 1)), 
        //     isAllDay: false, 
        //     alerts: const []
        //   );
        // }).toList();
        // return Right(entities);
        return await getHistoryUsecase(NoParam());
      });
    });
    on<TaskGetMoreHistory>((event, emit) async {
      await getHistory(event, emit, () async {
        // final entities = List<int>.generate(20, (index) => index).map((v) {
        //   final start = DateTime.parse("2022-07-03 00:00:00").add(Duration(hours: v + 1));
        //   return TaskEntity(
        //     id: v.toString(),
        //     title: "hello title $v",
        //     description: "hello description $v", 
        //     start: start, 
        //     end: start.add(const Duration(hours: 1)), 
        //     isAllDay: false, 
        //     alerts: const []
        //   );
        // }).toList();
        // return Right(entities);
        return await getMoreHistoryUsecase(NoParam());
      });
    });
    on<TaskGetRefreshHistory>((event, emit) async {
      await getHistory(event, emit, () async {
        // final entities = List<int>.generate(10, (index) => index).map((v) {
        //   final start = DateTime.parse("2022-07-03 00:00:00").add(Duration(hours: v + 1));
        //   return TaskEntity(
        //     id: v.toString(),
        //     title: "hello title $v",
        //     description: "hello description $v", 
        //     start: start, 
        //     end: start.add(const Duration(hours: 1)), 
        //     isAllDay: false, 
        //     alerts: const []
        //   );
        // }).toList();
        // return Right(entities);
        return await getRefreshHistoryUsecase(NoParam());
      });
    });
    on<TaskResetGeneralError>((event, emit) {
      emit(TaskIdle(models: state.models));
    });
  }

  getHistory(TaskEvent event, Emitter<TaskState> emit, Usecase usecase) async {
    emit(TaskLoading(models: state.models));

    final response = await usecase();
    response.fold(
      (error) {
        List<TaskModel> models = (error.data as List<dynamic>).map((entity) {
          final temp = entity as TaskEntity;
          return TaskModel.fromTaskEntity(temp);
        }).toList();
        emit(TaskGeneralError(models: models, message: error.message));
      },
      (result) {
        List<TaskModel> models = result.map((entity) => TaskModel.fromTaskEntity(entity)).toList();
        emit(TaskLoaded(models: models));
        emit(TaskIdle(models: models));
      }
    );
  }

}