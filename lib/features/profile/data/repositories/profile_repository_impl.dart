import 'package:crosscheck/core/error/exception.dart';
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
  Future<Either<Failure, ProfileEntity>> getProfile({required String token}) async {
    try {
      bool isConnected = await networkInfo.isConnected;

      if (!isConnected) {
        final data = await local.getProfile();
        return Right(data);
      }

      final response = await remote.getProfile(token: token);
      final data = response.profileModel;
      await local.setProfile(data);
      return Right(data);  
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
    
  }
  
}