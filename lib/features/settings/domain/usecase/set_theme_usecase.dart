import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/usecase/usecase.dart';
import 'package:crosscheck/features/settings/data/models/data/settings_model.dart';
import 'package:crosscheck/features/settings/domain/repositories/settings_repository.dart';
import 'package:dartz/dartz.dart';

class SetThemeUsecase implements Usecase<void, SettingsModel> {

  final SettingsRepository repository;

  const SetThemeUsecase({required this.repository});
  
  @override
  Future<Either<Failure, void>> call(SettingsModel params) async {

    try {
      await repository.setTheme(params);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CachedFailure(message: e.message));
    }
  }
  
}