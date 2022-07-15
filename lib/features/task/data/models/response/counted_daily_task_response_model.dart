import 'package:crosscheck/core/response/response.dart';
import 'package:crosscheck/features/task/data/models/data/counted_daily_task_model.dart';

class CountedDailyTaskResponseModel extends Response {
  
  const CountedDailyTaskResponseModel({required super.message, required super.data});

  factory CountedDailyTaskResponseModel.fromJSON(Map<String, dynamic> response) {
    final bool isDataNull = response["data"] == null;
    return CountedDailyTaskResponseModel(
      message: response["message"],
      data: isDataNull ? [] : (response["data"] as List).map((item) => CountedDailyTaskModel.fromJSON(item)).toList()
    );
  }
  
  Map<String, dynamic> toJSON() {
    return {
      message: message,
      data: (data as List<CountedDailyTaskModel>).map((item) => item.toJSON()).toList()
    };
  }

  List<CountedDailyTaskModel> get models => data as List<CountedDailyTaskModel>;

}