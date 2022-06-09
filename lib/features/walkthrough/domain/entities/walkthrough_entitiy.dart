import 'package:equatable/equatable.dart';

class WalkthroughEntity extends Equatable {
  final bool isSkip;

  const WalkthroughEntity({
    required this.isSkip
  });

  @override
  List<Object?> get props => [isSkip];
}