import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/features/main/data/datasource/main_local_data_source.dart';
import 'package:crosscheck/features/main/data/model/data/bottom_navigation_model.dart';
import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/main/domain/repositories/main_repository.dart';
import 'package:dartz/dartz.dart';

class MainRepositoryImpl implements MainRepository {

  final MainLocalDataSource mainLocalDataSource;

  const MainRepositoryImpl({
    required this.mainLocalDataSource
  });
  
  @override
  Future<Either<Failure, BottomNavigationEntity>> getActiveBottomNavigation() async {
    try {
      final response = await mainLocalDataSource.getActiveBottomNavigation();
      return Right(response);
    } on CacheException catch (e) {
      return Left(CachedFailure(message: e.message));
    }
  }

  @override
  Future<void> setActiveBottomNavigation(BottomNavigation currentPage) async {
    await mainLocalDataSource.setActiveBottomNavigation(BottomNavigationModel(currentPage: currentPage));
  }
  
}