import 'package:equatable/equatable.dart';

abstract class WalkthroughEvent extends Equatable {
  
  const WalkthroughEvent();

  @override
  List<Object?> get props => [];
}

class WalkthroughSetSkip extends WalkthroughEvent {
  final bool isSkip;

  const WalkthroughSetSkip({required this.isSkip});

  @override
  List<Object?> get props => [isSkip];
}

class WalkthroughGetSkip extends WalkthroughEvent {}