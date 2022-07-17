import 'package:crosscheck/features/task/domain/entities/monthly_task_entity.dart';
import 'package:hive/hive.dart';

part 'monthly_task_model.g.dart';

@HiveType(typeId: 2)
class MonthlyTaskModel extends MonthlyTaskEntity {

  @override
  @HiveField(0)
  String get id => super.id;

  @override
  @HiveField(1)
  DateTime get date => super.date;

  @override
  @HiveField(2)
  int get total => super.total;
  
  const MonthlyTaskModel({
    required super.id,
    required super.date,
    required super.total
  });

  factory MonthlyTaskModel.fromJSON(Map<String, dynamic> response) {
    return MonthlyTaskModel(
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