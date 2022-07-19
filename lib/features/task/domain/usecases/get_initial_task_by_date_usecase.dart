import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/usecase/usecase.dart';
import 'package:crosscheck/features/task/domain/entities/combine_task_entity.dart';
import 'package:dartz/dartz.dart';

class GetInitialTaskByDateUsecase extends Usecase<CombineTaskEntity, DateTime> {
  
  @override
  Future<Either<Failure, CombineTaskEntity>> call(DateTime param) {
    // TODO: implement call
    throw UnimplementedError();
  }
  
}