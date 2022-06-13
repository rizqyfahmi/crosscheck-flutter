import 'package:equatable/equatable.dart';

abstract class MainEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class MainSetActiveBottomNavigation extends MainEvent {
  final int currentPage;

  MainSetActiveBottomNavigation({
    required this.currentPage
  });

  @override
  List<Object?> get props => [currentPage];
}

class MainGetActiveBottomNavigation extends MainEvent {}
class MainResetActiveBottomNavigation extends MainEvent {}