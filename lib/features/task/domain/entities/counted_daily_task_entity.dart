import 'package:equatable/equatable.dart';

class CountedDailyTaskEntity extends Equatable {

  final String id;
  final DateTime date;
  final int total; //Total of task

  const CountedDailyTaskEntity({
    required this.id,
    required this.date,
    required this.total
  });
  
  @override
  List<Object?> get props => [id, date, total];
  
}