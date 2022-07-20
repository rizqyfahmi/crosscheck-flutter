import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/features/task/domain/entities/combine_task_entity.dart';
import 'package:crosscheck/features/task/domain/entities/monthly_task_entity.dart';
import 'package:crosscheck/features/task/domain/entities/task_entity.dart';
import 'package:crosscheck/features/task/domain/usecases/get_history_usecase.dart';
import 'package:crosscheck/features/task/domain/usecases/get_initial_task_by_date_usecase.dart';
import 'package:crosscheck/features/task/domain/usecases/get_monthly_task_usecase.dart';
import 'package:crosscheck/features/task/domain/usecases/get_more_history_usecase.dart';
import 'package:crosscheck/features/task/domain/usecases/get_refresh_history_usecase.dart';
import 'package:crosscheck/features/task/presentation/bloc/monthly_task_model.dart';
import 'package:crosscheck/features/task/presentation/bloc/task_event.dart';
import 'package:crosscheck/features/task/presentation/bloc/task_model.dart';
import 'package:crosscheck/features/task/presentation/bloc/task_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef Usecase = Future<Either<Failure, List<T>>> Function<T>();

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetHistoryUsecase getHistoryUsecase;
  final GetMoreHistoryUsecase getMoreHistoryUsecase;
  final GetRefreshHistoryUsecase getRefreshHistoryUsecase;
  final GetInitialTaskByDateUsecase getInitialTaskByDateUsecase;
  final GetMonthlyTaskUsecase getMonthlyTaskUsecase;
  
  TaskBloc({
    required this.getHistoryUsecase,
    required this.getMoreHistoryUsecase,
    required this.getRefreshHistoryUsecase,
    required this.getInitialTaskByDateUsecase,
    required this.getMonthlyTaskUsecase
  }) : super(TaskInit()) {
    on<TaskGetHistory>((event, emit) async {
      await getTask(event, emit, <TaskEntity>() async {
        return getHistoryUsecase(NoParam()) as Future<Either<Failure, List<TaskEntity>>>;
      });
    });
    on<TaskGetMoreHistory>((event, emit) async {
      await getTask(event, emit, <TaskEntity>() {
        return getMoreHistoryUsecase(NoParam()) as Future<Either<Failure, List<TaskEntity>>>;
      });
    });
    on<TaskGetRefreshHistory>((event, emit) async {
      await getTask(event, emit, <TaskEntity>() async {
        return getRefreshHistoryUsecase(NoParam()) as Future<Either<Failure, List<TaskEntity>>>;
      });
    });
    on<TaskResetGeneralError>((event, emit) {
      emit(TaskIdle(models: state.models, monthlyTaskModels: state.monthlyTaskModels));
    });
    on<TaskGetInitialByDate>((event, emit) async {
      emit(TaskLoading(models: state.models, monthlyTaskModels: state.monthlyTaskModels));

      final response = await getInitialTaskByDateUsecase(event.time);
      response.fold(
        (error) {
          final data = (error.data as CombineTaskEntity);
          
          List<MonthlyTaskModel> monthlyTaskModels = getMonthlyTaskModel(data.monthlyTaskEntities);
          List<TaskModel> taskModels = getTaskModel(data.taskEntities);

          emit(TaskGeneralError(models: taskModels, monthlyTaskModels: monthlyTaskModels, message: error.message));
        },
        (result) {
          List<MonthlyTaskModel> monthlyTaskModels = getMonthlyTaskModel(result.monthlyTaskEntities);
          List<TaskModel> taskModels = getTaskModel(result.taskEntities);

          emit(TaskLoaded(models: taskModels, monthlyTaskModels: monthlyTaskModels));
          emit(TaskIdle(models: taskModels, monthlyTaskModels: monthlyTaskModels));
        }
      );
    });
    on<TaskGetMonthlyTask>((event, emit) async {
      await getMonthlyTask(event, emit, <MonthlyTaskEntity>() {
        return getMonthlyTaskUsecase(event.time) as Future<Either<Failure, List<MonthlyTaskEntity>>>;
      });
    });
  }

  List<MonthlyTaskModel> getMonthlyTaskModel(List<MonthlyTaskEntity> entities) {
    return entities.map((entity) {
      return MonthlyTaskModel.fromMonthlyTaskEntity(entity);
    }).toList();
  }

  List<TaskModel> getTaskModel(List<TaskEntity> entities) {
    return entities.map((entity) {
      return TaskModel.fromTaskEntity(entity);
    }).toList();
  }

  getTask(TaskEvent event, Emitter<TaskState> emit, Usecase usecase) async {
    emit(TaskLoading(models: state.models, monthlyTaskModels: state.monthlyTaskModels));

    final response = await usecase<TaskEntity>();
    response.fold(
      (error) {
        List<TaskModel> models = (error.data as List<dynamic>).map((entity) {
          final temp = entity as TaskEntity;
          return TaskModel.fromTaskEntity(temp);
        }).toList();
        emit(TaskGeneralError(models: models, monthlyTaskModels: state.monthlyTaskModels, message: error.message));
      },
      (result) {
        List<TaskModel> models = result.map((entity) => TaskModel.fromTaskEntity(entity)).toList();
        emit(TaskLoaded(models: models, monthlyTaskModels: state.monthlyTaskModels));
        emit(TaskIdle(models: models, monthlyTaskModels: state.monthlyTaskModels));
      }
    );
  }

  getMonthlyTask(TaskEvent event, Emitter<TaskState> emit, Usecase usecase) async {
    emit(TaskLoading(models: state.models, monthlyTaskModels: state.monthlyTaskModels));

    final response = await usecase<MonthlyTaskEntity>();
    response.fold(
      (error) {
        List<MonthlyTaskModel> monthlyTaskModels = (error.data as List<dynamic>).map((entity) {
          final temp = entity as MonthlyTaskEntity;
          return MonthlyTaskModel.fromMonthlyTaskEntity(temp);
        }).toList();
        emit(TaskGeneralError(models: state.models, monthlyTaskModels: monthlyTaskModels, message: error.message));
      },
      (result) {
        List<MonthlyTaskModel> monthlyTaskModels = result.map((entity) => MonthlyTaskModel.fromMonthlyTaskEntity(entity)).toList();
        emit(TaskLoaded(models: state.models, monthlyTaskModels: monthlyTaskModels));
        emit(TaskIdle(models: state.models, monthlyTaskModels: monthlyTaskModels));
      }
    );
  }

}