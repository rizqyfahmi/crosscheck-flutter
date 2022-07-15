import 'package:equatable/equatable.dart';

class CountedDailyTaskEntity extends Equatable {

  final DateTime date;
  final int total; //Total of task

  const CountedDailyTaskEntity({
    required this.date, required this.total
  });
  
  @override
  List<Object?> get props => [date, total];
  
}