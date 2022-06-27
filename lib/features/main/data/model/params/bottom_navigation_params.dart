import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart';
import 'package:equatable/equatable.dart';

class BottomNavigationParams extends Equatable {
  
  final BottomNavigation currentPage;

  const BottomNavigationParams({
    required this.currentPage
  });
  
  @override
  List<Object?> get props => [currentPage];
  
}