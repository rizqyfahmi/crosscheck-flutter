import 'package:crosscheck/features/dashboard/domain/entities/activity_entity.dart';

class ActivityModel extends ActivityEntity {

  final String progress;
  final bool isActive;

  const ActivityModel({
    required this.progress, 
    required this.isActive,
    required super.date, 
    required super.total
  });

  @override
  List<Object?> get props => [...super.props, progress, isActive];
}