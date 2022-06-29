import 'package:crosscheck/core/network/network_info.dart';
import 'package:crosscheck/features/profile/data/datasource/profile_local_data_source.dart';
import 'package:crosscheck/features/profile/data/datasource/profile_remote_data_source.dart';
import 'package:crosscheck/features/profile/domain/entities/profile_entity.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

class ProfileRepositoryImpl implements ProfileRepository {

  final ProfileRemoteDataSource remote;
  final ProfileLocalDataSource local;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.remote,
    required this.local,
    required this.networkInfo
  });
  
  @override
  Future<Either<Failure, ProfileEntity>> getProfile({required String token}) {
    // TODO: implement getProfile
    throw UnimplementedError();
  }
  
}