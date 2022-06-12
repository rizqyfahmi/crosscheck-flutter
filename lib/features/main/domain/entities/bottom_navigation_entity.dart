import 'package:equatable/equatable.dart';

class BottomNavigationEntity extends Equatable {
  
  final int currentPageIndex;

  const BottomNavigationEntity({
    required this.currentPageIndex
  });
  
  @override
  List<Object?> get props => [currentPageIndex];
  
}