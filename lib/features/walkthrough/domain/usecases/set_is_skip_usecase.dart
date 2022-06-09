import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/usecase/usecase.dart';
import 'package:crosscheck/features/walkthrough/data/models/request/walkthrough_params.dart';
import 'package:crosscheck/features/walkthrough/domain/repositories/walkthrough_repository.dart';
import 'package:dartz/dartz.dart';

class SetIsSkipUsecase implements Usecase<void, WalkthroughParams> {

  final WalkthroughRepository repository;

  SetIsSkipUsecase({required this.repository});
  
  @override
  Future<Either<Failure, void>> call(WalkthroughParams params) async {
    
    // TODO: implement call
    throw UnimplementedError();
  }
  
}