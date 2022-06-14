import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/usecase/usecase.dart';
import 'package:crosscheck/features/dashboard/data/models/params/dashboard_params.dart';
import 'package:crosscheck/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:crosscheck/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:dartz/dartz.dart';

class GetDashboardUsecase implements Usecase<DashboardEntity, DashboardParams> {
  
  final DashboardRepository repository;

  GetDashboardUsecase({
    required this.repository
  });
  
  @override
  Future<Either<Failure, DashboardEntity>> call(DashboardParams params) async {
    return await repository.getDashboard(params);
  }
  
}