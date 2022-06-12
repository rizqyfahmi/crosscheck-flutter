import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/core/usecase/usecase.dart';
import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart';
import 'package:crosscheck/features/main/domain/repositories/main_repository.dart';
import 'package:dartz/dartz.dart';

class GetActiveBottomNavigationUsecase implements Usecase<BottomNavigationEntity, NoParam> {

  final MainRepository repository;
 
  const GetActiveBottomNavigationUsecase({
    required this.repository
  });

  @override
  Future<Either<Failure, BottomNavigationEntity>> call(NoParam param) async {
    return await repository.getActiveBottomNavigation();
  }
  
}