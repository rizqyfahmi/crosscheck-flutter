import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/usecase/usecase.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:crosscheck/features/task/domain/entities/task_entity.dart';
import 'package:crosscheck/features/task/domain/repositories/task_respository.dart';
import 'package:dartz/dartz.dart';

class GetTaskByDateUsecase implements Usecase<List<TaskEntity>, DateTime> {

  final TaskRepository repository;
  final AuthenticationRepository authenticationRepository;

  GetTaskByDateUsecase({
    required this.repository,
    required this.authenticationRepository
  });
  
  @override
  Future<Either<Failure, List<TaskEntity>>> call(DateTime param) async {
    final response = await authenticationRepository.getToken();
    return response.fold(
      (error) => Left(error),
      (result) async => await repository.getTaskByDate(token: result.token, time: param)
    );
  }
  
}