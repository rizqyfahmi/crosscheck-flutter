import 'package:crosscheck/features/dashboard/data/models/data/activity_model.dart';
import 'package:crosscheck/features/dashboard/domain/entities/dashboard_entity.dart';

class DashboardModel extends DashboardEntity {
  
  const DashboardModel({required super.progress, required super.upcoming, required super.completed, required super.activities});

  factory DashboardModel.fromJSON(Map<String, dynamic> response) {
    return DashboardModel(
      progress: response["progress"], 
      upcoming: response["upcoming"], 
      completed: response["completed"], 
      activities: (response["activities"] as List<Map<String, dynamic>>).map(
        (res) => ActivityModel.fromJSON(res["activities"])
      ).toList()
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "progress": progress,
      "upcomming": upcoming,
      "completed": completed,
      "activities": activities.map((entity) {
        return ActivityModel.fromParent(entity).toJSON();
      })
    };
  }
  
}