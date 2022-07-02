import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/core/usecase/usecase.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:crosscheck/features/authentication/domain/usecases/authentication_usecase.dart';
import 'package:crosscheck/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:crosscheck/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:crosscheck/features/profile/domain/entities/profile_entity.dart';
import 'package:crosscheck/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

class GetDashboardUsecase implements Usecase<DashboardEntity, NoParam> {
  
  final DashboardRepository repository;
  final AuthenticationRepository authenticationRepository;
  final ProfileRepository profileRepository;

  GetDashboardUsecase({
    required this.repository,
    required this.authenticationRepository,
    required this.profileRepository
  });
  
  @override
  Future<Either<Failure, DashboardEntity>> call(NoParam params) async {
    final response = await AuthenticationUsecase(repository: authenticationRepository).call(NoParam());

    return response.fold(
      (error) => Left(error), 
      (result) async {
        final dashboardResponse = repository.getDashboard(token: result.token);
        final profileResponse = profileRepository.getProfile(token: result.token);

        final dashboardResult = await dashboardResponse;
        final profileResult = await profileResponse;

        if (dashboardResult.isLeft()) {
          return Left((dashboardResult as Left).value as Failure);
        }

        if (profileResult.isLeft()) {
          return Left((profileResult as Left).value as Failure);
        }

        final dashboardRight = (dashboardResult as Right).value as DashboardEntity;
        final profileRight = (profileResult as Right).value as ProfileEntity;

        return Right(DashboardEntity(
          upcoming: dashboardRight.upcoming,
          progress: dashboardRight.progress,
          completed: dashboardRight.completed,
          activities: dashboardRight.activities,
          fullname: profileRight.fullname,
          photoUrl: profileRight.photoUrl
        ));
      }
    );
  }
  
}