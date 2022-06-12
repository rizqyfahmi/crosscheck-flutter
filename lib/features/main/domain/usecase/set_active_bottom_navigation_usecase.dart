import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/usecase/usecase.dart';
import 'package:crosscheck/features/main/data/model/bottom_navigation_model.dart';
import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart';
import 'package:crosscheck/features/main/domain/repositories/main_repository.dart';
import 'package:dartz/dartz.dart';

class SetActiveBottomNavigationUsecase implements Usecase<BottomNavigationEntity, BottomNavigationModel> {

  final MainRepository repository;

  const SetActiveBottomNavigationUsecase({
    required this.repository
  });
  
  @override
  Future<Either<Failure, BottomNavigationEntity>> call(BottomNavigationModel param) {
    // TODO: implement call
    throw UnimplementedError();
  }

}