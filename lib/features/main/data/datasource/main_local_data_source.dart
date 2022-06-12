import 'package:crosscheck/features/main/data/model/bottom_navigation_model.dart';

abstract class MainLocalDataSource {
  
  Future<BottomNavigationModel> getActiveBottomNavigation();

}