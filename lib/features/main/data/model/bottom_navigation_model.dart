import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart';

class BottomNavigationModel extends BottomNavigationEntity implements Param {
  
  const BottomNavigationModel({required super.currentPageIndex});

  factory BottomNavigationModel.fromJSON(Map<String, dynamic> response) => BottomNavigationModel(currentPageIndex: response["currentPageIndex"]);

  Map<String, dynamic> toJSON() => {"currentPageIndex": super.currentPageIndex};
  
}