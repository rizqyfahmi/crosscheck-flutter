import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart';
import 'package:equatable/equatable.dart';

class MainModel extends Equatable {
  
  final BottomNavigation currentPage;

  const MainModel({
    required this.currentPage
  });

  MainModel copyWith({BottomNavigation? currentPage}) => MainModel(currentPage: currentPage ?? this.currentPage);

  @override
  List<Object?> get props => [currentPage];
  
}