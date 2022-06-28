import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:dartz/dartz.dart';

abstract class DashboardRepository {

  Future<Either<Failure, DashboardEntity>> getDashboard({
    required String token
  });
  
}