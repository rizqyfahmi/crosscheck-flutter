import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/walkthrough/data/models/request/walkthrough_params.dart';
import 'package:crosscheck/features/walkthrough/domain/entities/walkthrough_entitiy.dart';
import 'package:dartz/dartz.dart';

abstract class WalkthroughRepository {
  
  Future<Either<Failure, dynamic>> setIsSkip(WalkthroughParams params);
  
  Future<Either<Failure, WalkthroughEntity>> getIsSkip();

}