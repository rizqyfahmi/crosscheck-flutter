import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/task/domain/entities/monthly_task_entity.dart';
import 'package:crosscheck/features/task/domain/entities/task_entity.dart';
import 'package:dartz/dartz.dart';

abstract class TaskRepository {
  
  Future<Either<Failure, List<TaskEntity>>> getHistory(String token);
  
  Future<Either<Failure, List<TaskEntity>>> getMoreHistory(String token);

  Future<Either<Failure, List<TaskEntity>>> getRefreshHistory(String token);

  Future<Either<Failure, List<MonthlyTaskEntity>>> countDailyTaskByMonth({
    required String token,
    required DateTime time // YYYY-MM-01
  });

}