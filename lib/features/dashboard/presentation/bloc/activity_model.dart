import 'package:equatable/equatable.dart';

class ActivityModel extends Equatable {

  final String fullname;
  final String photoUrl;
  final String progress;
  final bool isActive;
  final double heightBar;
  final DateTime? date;
  final int total;

  const ActivityModel({
    this.fullname = "-",
    this.photoUrl = "",
    this.progress = "0%", 
    this.isActive = false,
    this.heightBar = 0,
    this.date, 
    this.total = 0,
  });

  @override
  List<Object?> get props => [progress, isActive, heightBar, date, total];
}