import 'package:equatable/equatable.dart';

class ActiviyEntitiy extends Equatable {
  
  final DateTime day;
  final double total;

  const ActiviyEntitiy({
    required this.day,
    required this.total
  });

  @override
  List<Object?> get props => [day, total];
  
}