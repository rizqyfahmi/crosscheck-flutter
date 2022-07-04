import 'package:crosscheck/features/task/data/models/response/task_response_model.dart';

abstract class TaskRemoteDataSource {
  
  Future<TaskResponseModel> getHistory({required String token});

}