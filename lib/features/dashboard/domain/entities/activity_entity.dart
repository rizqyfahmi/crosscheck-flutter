import 'package:equatable/equatable.dart';

class ActivityEntity extends Equatable {
  
  final DateTime date;
  final int total;

  const ActivityEntity({
    required this.date,
    required this.total
  });

  @override
  List<Object?> get props => [date, total];
  
}