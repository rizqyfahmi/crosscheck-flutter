import 'package:equatable/equatable.dart';

class WalkthroughModel extends Equatable {
  final bool isSkip;

  const WalkthroughModel({
    this.isSkip = false
  });

  WalkthroughModel copyWith({
    bool? isSkip
  }) {
    return WalkthroughModel(
      isSkip: isSkip ?? this.isSkip
    );
  }

  @override
  List<Object?> get props => [isSkip];
  
}