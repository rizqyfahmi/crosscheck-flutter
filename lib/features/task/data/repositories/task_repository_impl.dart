import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/network/network_info.dart';
import 'package:crosscheck/features/task/data/datasource/task_local_data_source.dart';
import 'package:crosscheck/features/task/data/datasource/task_remote_data_source.dart';
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
  Future<Either<Failure, void>> clearCachedHistory() {
    // TODO: implement clearCachedHistory
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getHistory(String token) async {
    try {
      List<TaskEntity> cachedTasks = await local.getCachedHistory();
      if (cachedTasks.isNotEmpty) {
        return Right(cachedTasks);
      }

      bool isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return const Right([]);
      }

      final response = await remote.getHistory(token: token);
      final data = response.tasks;
      await local.cacheHistory(data);
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
  
  @override
  Future<Either<Failure, List<TaskEntity>>> getMoreHistory(String token) {
    // TODO: implement getMoreHistory
    throw UnimplementedError();
  }

}