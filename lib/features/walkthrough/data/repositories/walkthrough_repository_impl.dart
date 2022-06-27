import 'package:crosscheck/features/walkthrough/data/datasource/walkthrough_local_data_source.dart';
import 'package:crosscheck/features/walkthrough/data/models/data/walkthrough_model.dart';
import 'package:crosscheck/features/walkthrough/domain/entities/walkthrough_entitiy.dart';
import 'package:crosscheck/features/walkthrough/data/models/request/walkthrough_params.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/walkthrough/domain/repositories/walkthrough_repository.dart';
import 'package:dartz/dartz.dart';

class WalkthroughRepositoryImpl implements WalkthroughRepository {
  
  final WalkthroughLocalDataSource walkthroughLocalDataSource;

  WalkthroughRepositoryImpl({
    required this.walkthroughLocalDataSource
  });

  @override
  Future<Either<Failure, WalkthroughEntity>> getIsSkip() async {
    try {
      final response = await walkthroughLocalDataSource.getIsSkip();
      return Right(response);
    } on CachedFailure catch (e) {
      return Left(CachedFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, dynamic>> setIsSkip(bool isSkip) async {
    
    try {
      await walkthroughLocalDataSource.setIsSkip(WalkthroughModel(isSkip: isSkip));
      return const Right(null);
    } on CachedFailure catch (e) {
      return Left(CachedFailure(message: e.message));
    }

  }
  
}