import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/task/data/models/data/monthly_task_model.dart';
import 'package:crosscheck/features/task/data/models/data/task_model.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

abstract class TaskLocalDataSource {

  Future<List<TaskModel>> getCachedTask();

  Future<void> cacheTask(List<TaskModel> models);

  Future<void> clearCachedTask();

  Future<void> cacheMonthlyTask(List<MonthlyTaskModel> models);

  Future<List<MonthlyTaskModel>> getCacheMonthlyTask(DateTime time);

  Future<void> clearCachedMonthlyTask();

  Future<List<TaskModel>> getCachedTaskByDate(DateTime time);

}

class TaskLocalDataSourceImpl implements TaskLocalDataSource  {
  
  final Box<TaskModel> taskBox;
  final Box<MonthlyTaskModel> monthlyTaskBox;

  TaskLocalDataSourceImpl({
    required this.taskBox,
    required this.monthlyTaskBox
  });

  @override
  Future<void> cacheTask(List<TaskModel> models) async {
    if(!taskBox.isOpen) throw const CacheException(message: Failure.cacheError);

    for (var element in models) {
      await taskBox.put(element.id, element);
    }
  }

  @override
  Future<List<TaskModel>> getCachedTask() {
    if (!taskBox.isOpen) return Future.value([]);
    
    final response = taskBox.values.toList();

    return Future.value(response);
  }
  
  @override
  Future<void> clearCachedTask() async {
    if (!taskBox.isOpen) throw const CacheException(message: Failure.cacheError);

    await taskBox.deleteAll(taskBox.keys);
  }
  
  @override
  Future<void> cacheMonthlyTask(List<MonthlyTaskModel> models) async {
    if(!monthlyTaskBox.isOpen) throw const CacheException(message: Failure.cacheError);

    for (var element in models) {
      await monthlyTaskBox.put(element.id, element);
    }
  }
  
  @override
  Future<List<MonthlyTaskModel>> getCacheMonthlyTask(DateTime time) {
    if (!monthlyTaskBox.isOpen) return Future.value([]);

    final response = monthlyTaskBox.values.where((item) {
      return DateFormat("YYYY-MM").format(item.date) == DateFormat("YYYY-MM").format(time);
    }).toList();

    return Future.value(response);
  }
  
  @override
  Future<void> clearCachedMonthlyTask() async {
    if (!monthlyTaskBox.isOpen) throw const CacheException(message: Failure.cacheError);

    await monthlyTaskBox.deleteAll(monthlyTaskBox.keys);
  }
  
  @override
  Future<List<TaskModel>> getCachedTaskByDate(DateTime time) {
    if (!taskBox.isOpen) return Future.value([]);

    final response = taskBox.values.where((item) {
      return (time.isAtSameMomentAs(item.start) || time.isAfter(item.start)) && (time.isAtSameMomentAs(item.end) || time.isBefore(item.end));
    }).toList();

    return Future.value(response);
  }
}