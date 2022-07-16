import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/network/network_info.dart';
import 'package:crosscheck/features/task/data/datasource/task_local_data_source.dart';
import 'package:crosscheck/features/task/data/datasource/task_remote_data_source.dart';
import 'package:crosscheck/features/task/data/models/data/monthly_task_model.dart';
import 'package:crosscheck/features/task/data/models/data/task_model.dart';
import 'package:crosscheck/features/task/domain/entities/monthly_task_entity.dart';
import 'package:crosscheck/features/task/domain/entities/task_entity.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/task/domain/repositories/task_respository.dart';
import 'package:dartz/dartz.dart';

class TaskRepositoryImpl extends TaskRepository {
  final TaskRemoteDataSource remote;
  final TaskLocalDataSource local;
  final NetworkInfo networkInfo;

  TaskRepositoryImpl({
    required this.remote,
    required this.local,
    required this.networkInfo
  });
  
  @override
  Future<Either<Failure, List<TaskEntity>>> getHistory(String token) async {
    List<TaskModel> cachedTasks = await local.getCachedHistory(); // this line always returns [] when an error is occured to make the controller still continue, then get the data from the remote 
    if (cachedTasks.isNotEmpty) {
      return Right(cachedTasks);
    }

    try {
      bool isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return Left(NetworkFailure(message: Failure.networkError, data: cachedTasks));
      }

      final response = await remote.getHistory(token: token);
      final data = response.tasks;
      await local.cacheHistory(data); // this line is required so that we still make it throws an exception when an error is occured to synchronize the data
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, data: cachedTasks));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, data: cachedTasks));
    }
  }
  
  @override
  Future<Either<Failure, List<TaskEntity>>> getMoreHistory(String token) async {
    List<TaskModel> cachedTasks = await local.getCachedHistory(); // this line always returns [] when an error is occured to make the controller still continue, then get the data from the remote 

    try {
      bool isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return Left(NetworkFailure(message: Failure.networkError, data: cachedTasks));
      }

      final response = await remote.getHistory(token: token, offset: cachedTasks.length);
      final data = [...cachedTasks, ...response.tasks];
      await local.cacheHistory(data); // this line is required so that we still make it throws an exception when an error is occured to synchronize the data
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, data: cachedTasks));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, data: cachedTasks));
    }
  }
  
  @override
  Future<Either<Failure, List<TaskEntity>>> getRefreshHistory(String token) async {
    List<TaskModel> cachedTasks = await local.getCachedHistory(); // this line always returns [] when an error is occured to make the controller still continue, then get the data from the remote 
    
    try {
      await local.clearCachedHistory();
    
      final response = await remote.getHistory(token: token);
      final data = response.tasks;
      await local.cacheHistory(data); // this line is required so that we still make it throws an exception when an error is occured to synchronize the data
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, data: cachedTasks));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, data: cachedTasks));
    }
  }

  @override
  Future<Either<Failure, List<MonthlyTaskEntity>>> getMonthlyTask({required String token, required DateTime time}) async {
    List<MonthlyTaskModel> cachedData = await local.getCacheCountDailyTask();

    try {
      bool isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return Left(NetworkFailure(message: Failure.networkError, data: cachedData));
      }

      final response = await remote.countDailyTask(token: token, time: time);
      final data = response.models;
      await local.cacheCountDailyTask(data);
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, data: cachedData));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, data: cachedData));
    }

  }

}