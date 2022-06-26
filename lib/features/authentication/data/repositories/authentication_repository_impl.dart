import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/network/network_info.dart';
import 'package:crosscheck/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:crosscheck/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:crosscheck/features/authentication/data/models/data/authentication_model.dart';
import 'package:crosscheck/features/authentication/data/models/request/login_params.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
import 'package:crosscheck/features/authentication/data/models/request/registration_params.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:dartz/dartz.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {

  final AuthenticationRemoteDataSource remote;
  final AuthenticationLocalDataSource local;
  final NetworkInfo networkInfo;

  AuthenticationRepositoryImpl({
    required this.remote,
    required this.local,
    required this.networkInfo
  });

  @override
  Future<Either<Failure, void>> registration(RegistrationParams params) async {
    bool isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkFailure());
    }
    
    try {
      final result = await remote.registration(params);
      local.setToken(AuthenticationModel(token: result.token));
      return const Right(null);
    } on ServerException catch(e) {
      return Left(ServerFailure(message: e.message, errors: e.errors));
    } on CacheException catch(e) {
      return Left(CachedFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> login(LoginParams params) async {
    
    bool isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkFailure());
    }
    
    try {
      final result = await remote.login(params);
      local.setToken(AuthenticationModel(token: result.token));
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, errors: e.errors));
    } on CacheException catch (e) {
      return Left(CachedFailure(message: e.message));
    }
    
  }
  
  @override
  Future<Either<Failure, AuthenticationEntity>> getToken() async {
    try {
      final response = await local.getToken();
      return Right(response);
    } on CacheException catch (e) {
      return Left(CachedFailure(message: e.message));
    }
  }
  
}