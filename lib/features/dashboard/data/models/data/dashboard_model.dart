import 'package:crosscheck/features/dashboard/data/models/data/activity_model.dart';
import 'package:crosscheck/features/dashboard/domain/entities/dashboard_entity.dart';

class DashboardModel extends DashboardEntity {
  
  const DashboardModel({required super.progress, required super.upcoming, required super.completed, required super.activities});

  factory DashboardModel.fromJSON(Map<String, dynamic> response) {
    // print("response: ${response["activities"]}");
    final upcoming = (response["upcoming"] as int);
    final completed = (response["completed"] as int);
    return DashboardModel(
      progress: completed / (upcoming + completed), 
      upcoming: upcoming, 
      completed: completed, 
      activities: (response["activities"] as List<dynamic>).map(
        (res) => ActivityModel.fromJSON(res)
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