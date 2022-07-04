import 'package:crosscheck/features/task/data/models/data/task_model.dart';

abstract class TaskLocalDataSource {

  Future<List<TaskModel>> getCachedHistory();

  Future<void> cacheHistory(List<TaskModel> models);

}