import 'package:crosscheck/core/response/response.dart';
import 'package:crosscheck/features/task/data/models/data/monthly_task_model.dart';

class MonthlyTaskResponseModel extends Response {
  
  const MonthlyTaskResponseModel({required super.message, required super.data});

  factory MonthlyTaskResponseModel.fromJSON(Map<String, dynamic> response) {
    final bool isDataNull = response["data"] == null;
    return MonthlyTaskResponseModel(
      message: response["message"],
      data: isDataNull ? [] : (response["data"] as List).map((item) => MonthlyTaskModel.fromJSON(item)).toList()
    );
  }
  
  Map<String, dynamic> toJSON() {
    return {
      message: message,
      data: (data as List<MonthlyTaskModel>).map((item) => item.toJSON()).toList()
    };
  }

  List<MonthlyTaskModel> get models => data as List<MonthlyTaskModel>;

}