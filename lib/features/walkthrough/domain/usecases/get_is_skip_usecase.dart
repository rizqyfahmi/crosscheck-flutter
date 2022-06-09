import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/core/usecase/usecase.dart';
import 'package:crosscheck/features/walkthrough/domain/entities/walkthrough_entitiy.dart';
import 'package:crosscheck/features/walkthrough/domain/repositories/walkthrough_repository.dart';
import 'package:dartz/dartz.dart';

class GetIsSkipUsecase implements Usecase<WalkthroughEntity, NoParam> {

  final WalkthroughRepository repository;

  GetIsSkipUsecase({
    required this.repository
  });

  @override
  Future<Either<Failure, WalkthroughEntity>> call(NoParam param) async {
    return await repository.getIsSkip();
  }
  
}