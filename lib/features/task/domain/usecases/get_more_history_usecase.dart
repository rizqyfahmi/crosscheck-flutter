import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/core/usecase/usecase.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:crosscheck/features/task/domain/entities/task_entity.dart';
import 'package:crosscheck/features/task/domain/repositories/task_respository.dart';
import 'package:dartz/dartz.dart';

class GetMoreHistoryUsecase implements Usecase<TaskEntity, NoParam> {

  final TaskRepository repository;
  final AuthenticationRepository authenticationRepository;

  GetMoreHistoryUsecase({
    required this.repository,
    required this.authenticationRepository
  });

  @override
  Future<Either<Failure, TaskEntity>> call(NoParam param) {
    // TODO: implement call
    throw UnimplementedError();
  }
}