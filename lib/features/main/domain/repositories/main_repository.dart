import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart';
import 'package:dartz/dartz.dart';

abstract class MainRepository {
  
  Future<Either<Failure, BottomNavigationEntity>> getActiveBottomNavigation();

  Future<void> setActiveBottomNavigation(BottomNavigation currentPage);

}