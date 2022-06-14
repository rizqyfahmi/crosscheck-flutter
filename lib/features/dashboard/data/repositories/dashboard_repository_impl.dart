import 'package:crosscheck/core/network/network_info.dart';
import 'package:crosscheck/features/dashboard/data/datasource/dashboard_remote_data_source.dart';
import 'package:crosscheck/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:crosscheck/features/dashboard/data/models/params/dashboard_params.dart';
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
  Future<Either<Failure, DashboardEntity>> getDashboard(DashboardParams params) {
    // TODO: implement getDashboard
    throw UnimplementedError();
  }
  
}