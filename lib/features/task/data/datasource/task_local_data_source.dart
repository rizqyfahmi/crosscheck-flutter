import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/task/data/models/data/task_model.dart';
import 'package:hive/hive.dart';

abstract class TaskLocalDataSource {

  Future<List<TaskModel>> getCachedHistory();

  Future<void> cacheHistory(List<TaskModel> models);

  Future<void> clearCachedHistory();

}

class TaskLocalDataSourceImpl implements TaskLocalDataSource  {
  
  final Box<TaskModel> box;

  TaskLocalDataSourceImpl({
    required this.box
  });

  @override
  Future<void> cacheHistory(List<TaskModel> models) async {
    if(!box.isOpen) throw const CacheException(message: Failure.cacheError);

    for (var element in models) {
      await box.put(element.id, element);
    }
  }

  @override
  Future<List<TaskModel>> getCachedHistory() {
    if (!box.isOpen) return Future.value([]);
    
    final response = box.values.toList();

    return Future.value(response);
  }
  
  @override
  Future<void> clearCachedHistory() async {
    if (!box.isOpen) throw const CacheException(message: Failure.cacheError);

    await box.deleteAll(box.keys);
  }
}