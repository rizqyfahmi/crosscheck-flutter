import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/usecase/usecase.dart';
import 'package:crosscheck/features/main/data/model/params/bottom_navigation_params.dart';
import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart';
import 'package:crosscheck/features/main/domain/repositories/main_repository.dart';
import 'package:dartz/dartz.dart';

class SetActiveBottomNavigationUsecase implements Usecase<BottomNavigationEntity, BottomNavigationParams> {

  final MainRepository repository;

  const SetActiveBottomNavigationUsecase({
    required this.repository
  });
  
  @override
  Future<Either<Failure, BottomNavigationEntity>> call(BottomNavigationParams params) async {
    
    try {
      await repository.setActiveBottomNavigation(params.currentPage);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
    return await repository.getActiveBottomNavigation();

  }

}