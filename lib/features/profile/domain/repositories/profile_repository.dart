import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/profile/domain/entities/profile_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ProfileRepository {
  
  Future<Either<Failure, ProfileEntity>> getProfile({required String token});

}