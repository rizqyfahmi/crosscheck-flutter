import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/main/data/model/bottom_navigation_model.dart';
import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart';
import 'package:dartz/dartz.dart';

abstract class MainRepository {
  
  Future<Either<Failure, BottomNavigationEntity>> getActiveBottomNavigation();

  Future<void> setActiveBottomNavigation(BottomNavigationModel param);

}