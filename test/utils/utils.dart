import 'package:crosscheck/features/dashboard/domain/entities/activity_entity.dart';
import 'package:crosscheck/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:crosscheck/features/profile/domain/entities/profile_entity.dart';
import 'package:crosscheck/features/task/domain/entities/task_entity.dart';

class Utils {

  static const token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";
  static const successMessage = "The request has succeeded";
  final currentDate = DateTime.parse("2022-06-14"); 
  static final profileEntity = ProfileEntity(id: "123", fullname: "fulan", email: "fulan@email.com", dob: DateTime.parse("1991-01-11"), address: "Indonesia", photoUrl: "https://via.placeholder.com/60x60");

  List<ActivityEntity> get activityEntity {
    return [
      ActivityEntity(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.monday)), total: 5),   
      ActivityEntity(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.tuesday)), total: 7),
      ActivityEntity(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.wednesday)), total: 3),
      ActivityEntity(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.thursday)), total: 2),
      ActivityEntity(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.friday)), total: 7),
      ActivityEntity(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.saturday)), total: 1),
      ActivityEntity(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.sunday)), total: 5),
    ];
  }

  DashboardEntity get dashboardEntity {
    return DashboardEntity(progress: 20, upcoming: 20, completed: 5, activities: activityEntity);
  }

  List<TaskEntity> get taskEntities {
    return List<int>.generate(10, (index) => index).map((v) {
      final start = DateTime.parse("2022-07-03 00:00:00").add(Duration(hours: v));
      return TaskEntity(
        title: "hello title $v",
        description: "hello description $v", 
        start: DateTime.parse("2022-07-03 00:00:00").add(Duration(hours: v)), 
        end: start.add(Duration(hours: v)), 
        isAllDay: false, 
        alerts: const []
      );
    }).toList();
  }
}