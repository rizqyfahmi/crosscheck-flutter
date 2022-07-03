import 'package:crosscheck/features/task/domain/entities/task_entity.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/task/domain/repositories/task_respository.dart';
import 'package:dartz/dartz.dart';

class TaskRepositoryImpl extends TaskRepository {
  
  @override
  Future<Either<Failure, void>> clearCachedHistory() {
    // TODO: implement clearCachedHistory
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getHistory(String token) {
    // TODO: implement getHistory
    throw UnimplementedError();
  }

}