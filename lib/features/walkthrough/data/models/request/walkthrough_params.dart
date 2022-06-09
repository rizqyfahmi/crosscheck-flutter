import 'package:crosscheck/core/param/param.dart';

class WalkthroughParams extends Param {

  final bool isSkip;

  WalkthroughParams({required this.isSkip});

  factory WalkthroughParams.fromJSON(Map<String, dynamic> response) => WalkthroughParams(isSkip: response["isSkip"]);
  
  Map<String, dynamic> toJSON() => {"isSkip": isSkip};

}