import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/task/data/models/data/monthly_task_model.dart';
import 'package:crosscheck/features/task/data/models/data/task_model.dart';
import 'package:hive/hive.dart';

abstract class TaskLocalDataSource {

  Future<List<TaskModel>> getCachedHistory();

  Future<void> cacheHistory(List<TaskModel> models);

  Future<void> clearCachedHistory();

  Future<void> cacheCountDailyTask(List<MonthlyTaskModel> models);

  Future<List<MonthlyTaskModel>> getCacheCountDailyTask();

  Future<void> clearCachedDailyTask();

}

class TaskLocalDataSourceImpl implements TaskLocalDataSource  {
  
  final Box<TaskModel> taskBox;
  final Box<MonthlyTaskModel> monthlyTaskBox;

  TaskLocalDataSourceImpl({
    required this.taskBox,
    required this.monthlyTaskBox
  });

  @override
  Future<void> cacheHistory(List<TaskModel> models) async {
    if(!taskBox.isOpen) throw const CacheException(message: Failure.cacheError);

    for (var element in models) {
      await taskBox.put(element.id, element);
    }
  }

  @override
  Future<List<TaskModel>> getCachedHistory() {
    if (!taskBox.isOpen) return Future.value([]);
    
    final response = taskBox.values.toList();

    return Future.value(response);
  }
  
  @override
  Future<void> clearCachedHistory() async {
    if (!taskBox.isOpen) throw const CacheException(message: Failure.cacheError);

    await taskBox.deleteAll(taskBox.keys);
  }
  
  @override
  Future<void> cacheCountDailyTask(List<MonthlyTaskModel> models) async {
    if(!monthlyTaskBox.isOpen) throw const CacheException(message: Failure.cacheError);

    for (var element in models) {
      await monthlyTaskBox.put(element.id, element);
    }
  }
  
  @override
  Future<List<MonthlyTaskModel>> getCacheCountDailyTask() {
    if (!monthlyTaskBox.isOpen) return Future.value([]);

    final response = monthlyTaskBox.values.toList();

    return Future.value(response);
  }
  
  @override
  Future<void> clearCachedDailyTask() async {
    if (!monthlyTaskBox.isOpen) throw const CacheException(message: Failure.cacheError);

    await monthlyTaskBox.deleteAll(monthlyTaskBox.keys);
  }
}