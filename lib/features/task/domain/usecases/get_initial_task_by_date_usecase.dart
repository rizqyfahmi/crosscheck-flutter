import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/usecase/usecase.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:crosscheck/features/task/domain/entities/combine_task_entity.dart';
import 'package:crosscheck/features/task/domain/entities/monthly_task_entity.dart';
import 'package:crosscheck/features/task/domain/entities/task_entity.dart';
import 'package:crosscheck/features/task/domain/repositories/task_respository.dart';
import 'package:dartz/dartz.dart';

class GetInitialTaskByDateUsecase extends Usecase<CombineTaskEntity, DateTime> {

  final TaskRepository repository;
  final AuthenticationRepository authenticationRepository;

  GetInitialTaskByDateUsecase({
    required this.repository,
    required this.authenticationRepository
  });
  
  @override
  Future<Either<Failure, CombineTaskEntity>> call(DateTime param) async {
    final response = await authenticationRepository.getToken();
    return response.fold(
      (error) => Left(error), 
      (result) async {
        final monthlyTaskResponse = repository.getMonthlyTask(token: result.token, time: param);
        final taskResponse = repository.getTaskByDate(token: result.token, time: param);

        final monthlyTaskResult = await monthlyTaskResponse;
        final taskResult = await taskResponse;

        final monthlyTaskEntities = getMonthlyTaskEntities(monthlyTaskResult);
        final taskEntities = getTaskEntities(taskResult);
        final data = CombineTaskEntity(monthlyTaskEntities: monthlyTaskEntities, taskEntities: taskEntities);

        if (monthlyTaskResult.isLeft() && taskResult.isLeft()) {
          return Left(
            UnexpectedFailure(
              message: Failure.generalError,
              data: data
            )
          );
        }

        if (monthlyTaskResult.isLeft()) {
          return Left(
            getFailure((monthlyTaskResult as Left).value, data)
          );
        }

        if (taskResult.isLeft()) {
          return Left(
            getFailure((taskResult as Left).value, data)
          );
        }

        return Right(CombineTaskEntity(monthlyTaskEntities: monthlyTaskEntities, taskEntities: taskEntities));
      }
    );

  }

  List<MonthlyTaskEntity> getMonthlyTaskEntities(Either<Failure, List<MonthlyTaskEntity>> monthlyResult) {
    if (monthlyResult.isLeft()) {
      return ((monthlyResult as Left).value as Failure).data;
    }

    return (monthlyResult as Right).value as List<MonthlyTaskEntity>;
  }

  List<TaskEntity> getTaskEntities(Either<Failure, List<TaskEntity>> tasksResult) {
    if (tasksResult.isLeft()) {
      return ((tasksResult as Left).value as Failure).data;
    }

    return (tasksResult as Right).value as List<TaskEntity>;
  }

  Failure getFailure(dynamic value, CombineTaskEntity data) {
    if (value is ServerFailure) {
      return ServerFailure(
        message: value.message,
        data: data
      );
    }

    if (value is CacheFailure) {
      return CacheFailure(
        message: value.message,
        data: data
      );
    }

    return UnexpectedFailure(
      message: Failure.generalError,
      data: data
    );
  }

}