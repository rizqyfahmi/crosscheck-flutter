import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/usecase/usecase.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:crosscheck/features/profile/data/models/params/profile_params.dart';
import 'package:crosscheck/features/profile/domain/entities/profile_entity.dart';
import 'package:crosscheck/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

class GetProfileUsecase implements Usecase<ProfileEntity, ProfileParams> {

  final ProfileRepository repository;
  final AuthenticationRepository authenticationRepository;

  GetProfileUsecase({
    required this.repository,
    required this.authenticationRepository
  });

  @override
  Future<Either<Failure, ProfileEntity>> call(ProfileParams param) {
    // TODO: implement call
    throw UnimplementedError();
  }
}