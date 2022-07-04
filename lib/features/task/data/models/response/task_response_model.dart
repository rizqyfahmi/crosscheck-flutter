import 'package:crosscheck/core/response/response.dart';
import 'package:crosscheck/features/task/data/models/data/task_model.dart';

class TaskResponseModel extends Response {
  
  const TaskResponseModel({required super.message, required super.data});
  
  factory TaskResponseModel.fromJSON(Map<String, dynamic> response) {
    final bool isDataNull = response["data"] == null;

    return TaskResponseModel(
      message: response["message"], 
      data: isDataNull ? [] : (response["data"] as List).map((item) => TaskModel.fromJSON(item)).toList()
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "message": message,
      "data": (data).map((item) => item.toJSON()).toList()
    };
  }

  List<TaskModel> get tasks => data as List<TaskModel>;
}