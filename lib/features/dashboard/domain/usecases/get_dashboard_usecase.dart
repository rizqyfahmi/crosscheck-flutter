import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/core/usecase/usecase.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:crosscheck/features/authentication/domain/usecases/authentication_usecase.dart';
import 'package:crosscheck/features/dashboard/data/models/params/dashboard_params.dart';
import 'package:crosscheck/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:crosscheck/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:dartz/dartz.dart';

class GetDashboardUsecase implements Usecase<DashboardEntity, NoParam> {
  
  final DashboardRepository repository;
  final AuthenticationRepository authenticationRepository;

  GetDashboardUsecase({
    required this.repository,
    required this.authenticationRepository
  });
  
  @override
  Future<Either<Failure, DashboardEntity>> call(NoParam params) async {
    final response = await AuthenticationUsecase(repository: authenticationRepository).call(NoParam());

    return response.fold(
      (error) => Left(error), 
      (result) async => await repository.getDashboard(token: result.token)
    );
  }
  
}