import 'package:crosscheck/features/walkthrough/domain/entities/walkthrough_entitiy.dart';

class WalkthroughModel extends WalkthroughEntity {

  const WalkthroughModel({required super.isSkip});

  factory WalkthroughModel.fromJSON(Map<String, dynamic> response) => WalkthroughModel(isSkip: response["isSkip"]);
  
  Map<String, dynamic> toJSON() => {"isSkip": super.isSkip};
}