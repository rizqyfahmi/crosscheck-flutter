import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/task/data/models/data/counted_daily_task_model.dart';
import 'package:crosscheck/features/task/data/models/data/task_model.dart';
import 'package:hive/hive.dart';

abstract class TaskLocalDataSource {

  Future<List<TaskModel>> getCachedHistory();

  Future<void> cacheHistory(List<TaskModel> models);

  Future<void> clearCachedHistory();

  Future<void> cacheCountDailyTask(List<CountedDailyTaskModel> models);

  Future<List<CountedDailyTaskModel>> getCacheCountDailyTask();

  Future<void> clearCachedDailyTask();

}

class TaskLocalDataSourceImpl implements TaskLocalDataSource  {
  
  final Box<TaskModel> taskBox;
  final Box<CountedDailyTaskModel> countedDailyTaskBox;

  TaskLocalDataSourceImpl({
    required this.taskBox,
    required this.countedDailyTaskBox
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
  Future<void> cacheCountDailyTask(List<CountedDailyTaskModel> models) async {
    if(!countedDailyTaskBox.isOpen) throw const CacheException(message: Failure.cacheError);

    for (var element in models) {
      await countedDailyTaskBox.put(element.id, element);
    }
  }
  
  @override
  Future<List<CountedDailyTaskModel>> getCacheCountDailyTask() {
    if (!countedDailyTaskBox.isOpen) return Future.value([]);

    final response = countedDailyTaskBox.values.toList();

    return Future.value(response);
  }
  
  @override
  Future<void> clearCachedDailyTask() async {
    if (!countedDailyTaskBox.isOpen) throw const CacheException(message: Failure.cacheError);

    await countedDailyTaskBox.deleteAll(countedDailyTaskBox.keys);
  }
}