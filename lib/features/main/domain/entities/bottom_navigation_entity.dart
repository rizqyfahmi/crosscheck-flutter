import 'package:equatable/equatable.dart';

enum BottomNavigation {
  home,
  event,
  history,
  setting
}

class BottomNavigationEntity extends Equatable {
  
  final BottomNavigation currentPage;

  const BottomNavigationEntity({
    required this.currentPage
  });
  
  @override
  List<Object?> get props => [currentPage];
  
}