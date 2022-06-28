import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart';

class BottomNavigationModel extends BottomNavigationEntity implements Param {
  
  const BottomNavigationModel({required super.currentPage});

  factory BottomNavigationModel.fromJSON(Map<String, dynamic> response) => BottomNavigationModel(currentPage: BottomNavigation.values[response["currentPage"]]);

  Map<String, dynamic> toJSON() => {"currentPage": super.currentPage.index};
  
}