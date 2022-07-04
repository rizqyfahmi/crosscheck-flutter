
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:crosscheck/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:crosscheck/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:crosscheck/features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:crosscheck/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/utils.dart';
import 'get_dashboard_usecase_test.mocks.dart';

@GenerateMocks([
  DashboardRepository,
  AuthenticationRepository,
  ProfileRepository
])
void main() {
  late MockDashboardRepository mockDashboardRepository;
  late MockAuthenticationRepository mockAuthenticationRepository;
  late MockProfileRepository mockProfileRepository;
  late GetDashboardUsecase getDashboardUsecase;

  setUp(() {
    mockDashboardRepository = MockDashboardRepository();
    mockAuthenticationRepository = MockAuthenticationRepository();
    mockProfileRepository = MockProfileRepository();
    getDashboardUsecase = GetDashboardUsecase(
      repository: mockDashboardRepository,
      authenticationRepository: mockAuthenticationRepository,
      profileRepository: mockProfileRepository
    );
  });

  test("Should get DashboardEntity properly", () async {
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockDashboardRepository.getDashboard(token: Utils.token)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 3));
      return Right(Utils().dashboardEntity);
    });
    when(mockProfileRepository.getProfile(token: Utils.token)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 5));
      return Right(Utils.profileEntity);
    });

    final result = await getDashboardUsecase(NoParam());

    final expected = DashboardEntity(fullname: "fulan", photoUrl: "https://via.placeholder.com/60x60", progress: 20, upcoming: 20, completed: 5, activities: Utils().activityEntity);
    expect(result, Right(expected));
    verify(mockAuthenticationRepository.getToken());
    verify(mockDashboardRepository.getDashboard(token: Utils.token));
  });

  test("Should returns CacheFailure when get token is failed", () async {
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const  Left(CacheFailure(message: Failure.cacheError)));
    when(mockDashboardRepository.getDashboard(token: Utils.token)).thenAnswer((_) async => const Left(ServerFailure(message: Failure.generalError)));

    final result = await getDashboardUsecase(NoParam());

    expect(result, const Left(CacheFailure(message: Failure.cacheError)));
    verify(mockAuthenticationRepository.getToken());
    verifyNever(mockDashboardRepository.getDashboard(token: Utils.token));
  });

  test("Should returns ServerFailure when get dashboard is failed", () async {
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockDashboardRepository.getDashboard(token: Utils.token)).thenAnswer((_) async => const Left(ServerFailure(message: Failure.generalError)));
    when(mockProfileRepository.getProfile(token: Utils.token)).thenAnswer((_) async => Right(Utils.profileEntity));

    final result = await getDashboardUsecase(NoParam());

    expect(result, const Left(ServerFailure(message: Failure.generalError)));
    verify(mockAuthenticationRepository.getToken());
    verify(mockDashboardRepository.getDashboard(token: Utils.token));
  });

  test("Should returns ServerFailure when get profile is failed", () async {
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockDashboardRepository.getDashboard(token: Utils.token)).thenAnswer((_) async => Right(Utils().dashboardEntity));
    when(mockProfileRepository.getProfile(token: Utils.token)).thenAnswer((_) async => const Left(ServerFailure(message: Failure.generalError)));

    final result = await getDashboardUsecase(NoParam());

    expect(result, const Left(ServerFailure(message: Failure.generalError)));
    verify(mockAuthenticationRepository.getToken());
    verify(mockDashboardRepository.getDashboard(token: Utils.token));
  });

}