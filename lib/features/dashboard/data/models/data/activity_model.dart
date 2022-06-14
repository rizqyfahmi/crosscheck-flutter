import 'package:crosscheck/features/dashboard/domain/entities/activity_entity.dart';

class ActivityModel extends ActiviyEntitiy {
  
  const ActivityModel({required super.day, required super.total});

  factory ActivityModel.fromParent(ActiviyEntitiy entitiy) {
    return ActivityModel(day: entitiy.day, total: entitiy.total);
  }
  
  factory ActivityModel.fromJSON(Map<String, dynamic> response) {
    return ActivityModel(day: response["day"], total: response["total"]);
  }

  Map<String, dynamic> toJSON() {
    return {
      "day": day,
      "total": total
    };
  }
  
}