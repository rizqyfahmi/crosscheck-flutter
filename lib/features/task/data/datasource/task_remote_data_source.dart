import 'package:crosscheck/features/task/data/models/data/task_model.dart';

abstract class TaskRemoteDataSource {
  
  Future<List<TaskModel>> getHistory({required String token});

}