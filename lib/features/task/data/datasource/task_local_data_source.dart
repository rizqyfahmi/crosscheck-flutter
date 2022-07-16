import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/task/data/models/data/monthly_task_model.dart';
import 'package:crosscheck/features/task/data/models/data/task_model.dart';
import 'package:hive/hive.dart';

abstract class TaskLocalDataSource {

  Future<List<TaskModel>> getCachedTask();

  Future<void> cacheTask(List<TaskModel> models);

  Future<void> clearCachedTask();

  Future<void> cacheMonthlyTask(List<MonthlyTaskModel> models);

  Future<List<MonthlyTaskModel>> getCacheMonthlyTask();

  Future<void> clearCachedMonthlyTask();

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
  Future<List<MonthlyTaskModel>> getCacheMonthlyTask() {
    if (!monthlyTaskBox.isOpen) return Future.value([]);

    final response = monthlyTaskBox.values.toList();

    return Future.value(response);
  }
  
  @override
  Future<void> clearCachedMonthlyTask() async {
    if (!monthlyTaskBox.isOpen) throw const CacheException(message: Failure.cacheError);

    await monthlyTaskBox.deleteAll(monthlyTaskBox.keys);
  }
}