import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/main/data/datasource/main_local_data_source.dart';
import 'package:crosscheck/features/main/data/model/bottom_navigation_model.dart';
import 'package:crosscheck/features/main/data/repositories/main_repository_impl.dart';
import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart';
import 'package:crosscheck/features/main/domain/repositories/main_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'main_repository_impl_test.mocks.dart';

@GenerateMocks([
  MainLocalDataSource
])
void main() {
  late MockMainLocalDataSource mockMainLocalDataSource;
  late MainRepository mainRepository;

  setUp(() {
    mockMainLocalDataSource = MockMainLocalDataSource();
    mainRepository = MainRepositoryImpl(mainLocalDataSource: mockMainLocalDataSource);
  });

  test("Should BottomNavigationActivity when get active bottom navigation is success", () async {
    BottomNavigationEntity entity = const BottomNavigationModel(currentPage: BottomNavigation.event);

    when(mockMainLocalDataSource.getActiveBottomNavigation()).thenAnswer((_) async => const BottomNavigationModel(currentPage: BottomNavigation.event));

    final result = await mainRepository.getActiveBottomNavigation();

    expect(result, Right(entity));
    verify(mockMainLocalDataSource.getActiveBottomNavigation());

  });

  test("Should return CachedFailure when get active botom navigation is failed", () async {
    when(mockMainLocalDataSource.getActiveBottomNavigation()).thenThrow(CacheException(message: Failure.cacheError));

    final result = await mainRepository.getActiveBottomNavigation();

    expect(result, Left(CachedFailure(message: Failure.cacheError)));
    verify(mockMainLocalDataSource.getActiveBottomNavigation());

  });

  test("Should not throw CacheException when set active bottom navigation is success", () async {
    const param = BottomNavigationModel(currentPage: BottomNavigation.event);
    when(mockMainLocalDataSource.setActiveBottomNavigation(param)).thenAnswer((_) async => Future.value());

    await mainRepository.setActiveBottomNavigation(param);

    verify(mockMainLocalDataSource.setActiveBottomNavigation(param));
    
  });

  test("Should throw CacheException when set active bottom navigation is failed", () async {
    const param = BottomNavigationModel(currentPage: BottomNavigation.event);
    when(mockMainLocalDataSource.setActiveBottomNavigation(param)).thenThrow(CacheException(message: Failure.cacheError));

    final call = mainRepository.setActiveBottomNavigation;

    expect(call(param), throwsA(
      predicate((e) => e is CacheException)
    ));

    verify(mockMainLocalDataSource.setActiveBottomNavigation(param));
  });
}