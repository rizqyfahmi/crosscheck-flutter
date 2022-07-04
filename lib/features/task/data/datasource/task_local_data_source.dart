import 'package:crosscheck/features/task/data/models/data/task_model.dart';
import 'package:hive/hive.dart';

abstract class TaskLocalDataSource {

  Future<List<TaskModel>> getCachedHistory();

  Future<void> cacheHistory(List<TaskModel> models);

}

class TaskLocalDataSourceImpl implements TaskLocalDataSource  {
  
  final Box<TaskModel> box;

  TaskLocalDataSourceImpl({
    required this.box
  });

  @override
  Future<void> cacheHistory(List<TaskModel> models) {
    // TODO: implement cacheHistory
    throw UnimplementedError();
  }

  @override
  Future<List<TaskModel>> getCachedHistory() {
    // TODO: implement getCachedHistory
    throw UnimplementedError();
  }
}