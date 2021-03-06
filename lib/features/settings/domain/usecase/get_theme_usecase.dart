import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/core/usecase/usecase.dart';
import 'package:crosscheck/features/settings/domain/entities/settings_entity.dart';
import 'package:crosscheck/features/settings/domain/repositories/settings_repository.dart';
import 'package:dartz/dartz.dart';

class GetThemeUsecase implements Usecase<SettingsEntity, NoParam> {

  final SettingsRepository repository;

  GetThemeUsecase({required this.repository});
  
  @override
  Future<Either<Failure, SettingsEntity>> call(NoParam param) async {
    return await repository.getTheme();
  }
  
}