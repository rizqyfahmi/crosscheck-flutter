import 'package:crosscheck/features/dashboard/domain/entities/activity_entity.dart';

class ActivityModel extends ActivityEntity {
  
  const ActivityModel({required super.date, required super.total});

  factory ActivityModel.fromParent(ActivityEntity entitiy) {
    return ActivityModel(date: entitiy.date, total: entitiy.total);
  }
  
  factory ActivityModel.fromJSON(Map<String, dynamic> response) {
    return ActivityModel(date: DateTime.parse(response["date"]), total: response["total"]);
  }

  ActivityEntity toParent() {
    return ActivityEntity(date: date, total: total);
  }

  Map<String, dynamic> toJSON() {
    return {
      "date": date,
      "total": total
    };
  }
  
}