import 'package:crosscheck/features/task/domain/entities/monthly_task_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class MonthlyTaskModel extends Equatable {
  
  final String date;
  final String total;

  const MonthlyTaskModel({
    required this.date,
    required this.total
  });

  MonthlyTaskModel copyWith({
    String? date,
    String? total
  }) {
    return MonthlyTaskModel(
      date: date ?? this.date,
      total: total ?? this.total
    );
  }

  factory MonthlyTaskModel.fromMonthlyTaskEntity(MonthlyTaskEntity entity) {
    return MonthlyTaskModel(
      date: DateFormat("yyyy-MM-dd").format(entity.date),
      total: entity.total.toString()
    );
  }

  @override
  List<Object?> get props => [date, total];

}