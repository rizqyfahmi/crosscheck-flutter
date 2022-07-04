
import 'package:crosscheck/features/task/data/models/response/task_response_model.dart';
import 'package:http/http.dart';

abstract class TaskRemoteDataSource {
  
  Future<TaskResponseModel> getHistory({required String token});

}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {

  final Client client;

  TaskRemoteDataSourceImpl({
    required this.client
  });
  
  @override
  Future<TaskResponseModel> getHistory({required String token}) {
    // TODO: implement getHistory
    throw UnimplementedError();
  }

}