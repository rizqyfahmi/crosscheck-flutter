import 'dart:math';
import 'package:crosscheck/features/dashboard/domain/entities/activity_entity.dart';
import 'package:crosscheck/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:crosscheck/features/profile/domain/entities/profile_entity.dart';
import 'package:crosscheck/features/task/data/models/data/task_model.dart';
import 'package:crosscheck/features/task/domain/entities/counted_daily_task_entity.dart';
import 'package:crosscheck/features/task/domain/entities/task_entity.dart';
import 'package:intl/intl.dart';

class Utils {

  static const token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";
  static const successMessage = "The request has succeeded";
  final currentDate = DateTime.parse("2022-06-14"); 
  static final profileEntity = ProfileEntity(id: "123", fullname: "fulan", email: "fulan@email.com", dob: DateTime.parse("1991-01-11"), address: "Indonesia", photoUrl: "https://via.placeholder.com/60x60");
  Map<String, String> get headers => {'Content-Type': 'application/json', "Authorization": Utils.token};

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
      final start = DateTime.parse("2022-07-03 00:00:00").add(Duration(hours: v + 1));
      return TaskEntity(
        id: v.toString(),
        title: "hello title $v",
        description: "hello description $v", 
        start: start, 
        end: start.add(const Duration(hours: 1)), 
        isAllDay: false, 
        alerts: const []
      );
    }).toList();
  }

  List<TaskEntity> getTaskEntities({int start = 0, int end = 10}) {
    List<TaskEntity> results = [];
    for (var i = start; i < end; i++) {
      final start = DateTime.parse("2022-07-03 00:00:00").add(Duration(hours: i));
      final entity = TaskEntity(
        id: i.toString(),
        title: "hello title $i",
        description: "hello description $i", 
        start: start, 
        end: start.add(const Duration(hours: 1)), 
        isAllDay: false, 
        alerts: const []
      );
      results.add(entity);
    }

    return results;
  }

  List<TaskModel> get taskModels {
    return List<int>.generate(10, (index) => index).map((v) {
      final start = DateTime.parse("2022-07-03 00:00:00").add(Duration(hours: v + 1));
      return TaskModel(
        id: v.toString(),
        title: "hello title $v",
        description: "hello description $v", 
        start: start, 
        end: start.add(const Duration(hours: 1)), 
        isAllDay: false, 
        alerts: const []
      );
    }).toList();
  }

  List<TaskModel> get moreTaskModels {
    return List<int>.generate(10, (index) => index).map((v) {
      final index = v + 10;
      final start = DateTime.parse("2022-07-03 00:00:00").add(Duration(hours: index + 1));
      return TaskModel(
        id: index.toString(),
        title: "hello title $index",
        description: "hello description $index", 
        start: start, 
        end: start.add(const Duration(hours: 1)), 
        isAllDay: false, 
        alerts: const []
      );
    }).toList();
  }

  List<CountedDailyTaskEntity> getCountedDailyTaskEntity({required DateTime time}) {
    Random random = Random();
    int days = DateTime(time.year, time.month + 1, 0).day;
    return List<int>.generate(days, (index) => index).map((v) {
      int randomNumber = random.nextInt(90) + 1;
      return CountedDailyTaskEntity(
        id: DateFormat("YYYYMMDD").format(DateTime(2022, 7, v + 1)),
        date: DateTime(2022, 7, v + 1),
        total: randomNumber
      );
    }).toList();
  }
}