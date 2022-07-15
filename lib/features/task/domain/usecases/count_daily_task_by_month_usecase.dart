import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/usecase/usecase.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:crosscheck/features/task/domain/entities/counted_daily_task_entity.dart';
import 'package:crosscheck/features/task/domain/repositories/task_respository.dart';
import 'package:dartz/dartz.dart';

class CountDailyTaskByMonthUsecase implements Usecase<List<CountedDailyTaskEntity>, DateTime> {
  
  final TaskRepository repository;
  final AuthenticationRepository authenticationRepository;

  CountDailyTaskByMonthUsecase({
    required this.repository,
    required this.authenticationRepository
  });

  @override
  Future<Either<Failure, List<CountedDailyTaskEntity>>> call(DateTime param) async {
    final response = await authenticationRepository.getToken();

    return response.fold(
      (error) => Left(error),
      (result) async {
        return await repository.countDailyTaskByMonth(token: result.token, time: param);
      }
    );
  }
   
}