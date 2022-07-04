import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/core/usecase/usecase.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:crosscheck/features/task/domain/entities/task_entity.dart';
import 'package:crosscheck/features/task/domain/repositories/task_respository.dart';
import 'package:dartz/dartz.dart';

class GetRefreshHistoryUsecase implements Usecase<List<TaskEntity>, NoParam> {

  final TaskRepository repository;
  final AuthenticationRepository authenticationRepository;

  GetRefreshHistoryUsecase({
    required this.repository,
    required this.authenticationRepository
  });

  @override
  Future<Either<Failure, List<TaskEntity>>> call(NoParam param) async {
    final response = await authenticationRepository.getToken();
    return response.fold(
      (error) => Left(error),
      (result) async => await repository.getRefreshHistory(result.token)
    );
  }
}