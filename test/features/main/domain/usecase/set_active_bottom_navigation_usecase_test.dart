import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/main/data/model/data/bottom_navigation_model.dart';
import 'package:crosscheck/features/main/data/model/params/bottom_navigation_params.dart';
import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart';
import 'package:crosscheck/features/main/domain/repositories/main_repository.dart';
import 'package:crosscheck/features/main/domain/usecase/set_active_bottom_navigation_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'set_active_bottom_navigation_usecase_test.mocks.dart';

@GenerateMocks([
  MainRepository
])
void main() {
  late MockMainRepository mockMainRepository;
  late SetActiveBottomNavigationUsecase setActiveBottomNavigationUsecase;

  setUp(() {
    mockMainRepository = MockMainRepository();
    setActiveBottomNavigationUsecase = SetActiveBottomNavigationUsecase(repository: mockMainRepository);
  });

  test("Should return BottomNavigationEntity when set active bottom navigation is success", () async {
    const model = BottomNavigationModel(currentPage: BottomNavigation.event);
    BottomNavigationEntity entity = model;
    when(mockMainRepository.setActiveBottomNavigation(BottomNavigation.event)).thenAnswer((_) async => Future.value());
    when(mockMainRepository.getActiveBottomNavigation()).thenAnswer((_) async => const Right(model));

    final result = await setActiveBottomNavigationUsecase(const BottomNavigationParams(currentPage: BottomNavigation.event));

    expect(result, Right(entity));
    verify(mockMainRepository.setActiveBottomNavigation(BottomNavigation.event));
    verify(mockMainRepository.getActiveBottomNavigation());
  });

  test("Should return CachedFailure void when set active bottom navigation is failed", () async {
    when(mockMainRepository.setActiveBottomNavigation(BottomNavigation.event)).thenAnswer((_) async => Future.value());
    when(mockMainRepository.getActiveBottomNavigation()).thenAnswer((_) async => const  Left(CacheFailure(message: Failure.cacheError)));

    final result = await setActiveBottomNavigationUsecase(const BottomNavigationParams(currentPage: BottomNavigation.event));

    expect(result, const Left(CacheFailure(message: Failure.cacheError)));
    verify(mockMainRepository.setActiveBottomNavigation(BottomNavigation.event));
    verify(mockMainRepository.getActiveBottomNavigation());
  });

  test("Should return CacheException when set active bottom navigation is getting an exception", () async {
    when(mockMainRepository.setActiveBottomNavigation(BottomNavigation.event)).thenThrow(const CacheException(message: Failure.cacheError));
    

    final result = await setActiveBottomNavigationUsecase(const BottomNavigationParams(currentPage: BottomNavigation.event));

    expect(result, const Left(CacheFailure(message: Failure.cacheError)));
    verify(mockMainRepository.setActiveBottomNavigation(BottomNavigation.event));
    verifyNever(mockMainRepository.getActiveBottomNavigation());
  });
}