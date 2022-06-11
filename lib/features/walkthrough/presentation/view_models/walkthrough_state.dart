
import 'package:crosscheck/features/walkthrough/presentation/view_models/walkthrough_model.dart';
import 'package:equatable/equatable.dart';

abstract class WalkthroughState extends Equatable {
  
  final WalkthroughModel model;

  const WalkthroughState({
    required this.model
  });

  @override
  List<Object?> get props => [model];

}

class WalkthroughInitial extends WalkthroughState {
  
  const WalkthroughInitial() : super(model: const WalkthroughModel(isSkip: false));
  
}

class WalkthroughSkipSuccess extends WalkthroughState {
  
  const WalkthroughSkipSuccess({required super.model});

}

class WalkthroughSkipFailed extends WalkthroughState {

  final String message;
  
  const WalkthroughSkipFailed({
    required super.model,
    required this.message
  });

  @override
  List<Object?> get props => [...super.props, message];

}

class WalkthroughLoadSkipSuccess extends WalkthroughState {
  
  const WalkthroughLoadSkipSuccess({required super.model});

}

class WalkthroughLoadSkipFailed extends WalkthroughState {

  final String message;
  
  const WalkthroughLoadSkipFailed({
    required super.model,
    required this.message
  });

  @override
  List<Object?> get props => [...super.props, message];

}
