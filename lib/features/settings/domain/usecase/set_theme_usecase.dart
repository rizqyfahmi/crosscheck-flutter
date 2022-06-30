import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/usecase/usecase.dart';
import 'package:crosscheck/features/settings/data/models/params/settings_params.dart';
import 'package:crosscheck/features/settings/domain/repositories/settings_repository.dart';
import 'package:dartz/dartz.dart';

class SetThemeUsecase implements Usecase<void, SettingsParams> {

  final SettingsRepository repository;

  const SetThemeUsecase({required this.repository});
  
  @override
  Future<Either<Failure, void>> call(SettingsParams params) async {

    try {
      await repository.setTheme(params.themeMode);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
  
}