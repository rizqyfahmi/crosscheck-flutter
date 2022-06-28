import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/network/network_info.dart';
import 'package:crosscheck/features/dashboard/data/datasource/dashboard_remote_data_source.dart';
import 'package:crosscheck/features/dashboard/data/models/data/activity_model.dart';
import 'package:crosscheck/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:dartz/dartz.dart';

class DashboardRepositoryImpl implements DashboardRepository {

  final DashboardRemoteDataSource remote;
  final NetworkInfo networkInfo;

  const DashboardRepositoryImpl({
    required this.remote,
    required this.networkInfo
  });
  
  @override
  Future<Either<Failure, DashboardEntity>> getDashboard({required String token}) async {
    bool isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final response = await remote.getDashboard(token);
      final DashboardEntity entity = response.copyWith(
          activities: response.activities.map((e) {
        if (e is ActivityModel) return e.toParent();

        return e;
      }).toList());
      return Right(entity);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
  
}