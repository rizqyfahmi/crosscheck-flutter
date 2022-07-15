import 'package:crosscheck/features/task/domain/entities/counted_daily_task_entity.dart';

class CountedDailyTaskModel extends CountedDailyTaskEntity {
  
  const CountedDailyTaskModel({
    required super.id,
    required super.date,
    required super.total
  });

  factory CountedDailyTaskModel.fromJSON(Map<String, dynamic> response) {
    return CountedDailyTaskModel(
      id: response["id"],
      date: DateTime.parse(response["date"]),
      total: response["total"]
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "date": date,
      "total": total
    };
  }
  
}