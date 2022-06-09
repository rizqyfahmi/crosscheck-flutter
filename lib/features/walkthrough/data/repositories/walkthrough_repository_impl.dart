import 'package:crosscheck/features/walkthrough/data/datasource/walkthrough_local_data_storage.dart';
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
  Future<Either<Failure, WalkthroughEntity>> getIsSkip() {
    // TODO: implement getIsSkip
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, dynamic>> setIsSkip(WalkthroughParams params) async {
    // TODO: implement getIsSkip
    throw UnimplementedError();
  }
  
}