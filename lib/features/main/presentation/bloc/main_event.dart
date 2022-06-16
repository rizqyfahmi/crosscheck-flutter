import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart';
import 'package:equatable/equatable.dart';

abstract class MainEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class MainSetActiveBottomNavigation extends MainEvent {
  final BottomNavigation currentPage;

  MainSetActiveBottomNavigation({
    required this.currentPage
  });

  @override
  List<Object?> get props => [currentPage];
}

class MainGetActiveBottomNavigation extends MainEvent {}
class MainResetActiveBottomNavigation extends MainEvent {}
class MainShowLoading extends MainEvent {}
class MainHideLoading extends MainEvent {}
class MainSetGeneralError extends MainEvent {
  final String message;

  MainSetGeneralError({required this.message});

  @override
  List<Object?> get props => [message];

}
class MainResetGeneralError extends MainEvent {}