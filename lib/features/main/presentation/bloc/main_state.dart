import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_model.dart';
import 'package:equatable/equatable.dart';

abstract class MainState extends Equatable {
  final MainModel model;

  const MainState({
    required this.model
  });

  @override
  List<Object?> get props => [model];

}

class MainInit extends MainState {
  const MainInit() : super(model: const MainModel(currentPage: BottomNavigation.home));
}

class MainChanged extends MainState {
  const MainChanged({required super.model});
}

class MainLoading extends MainState {
  const MainLoading({required super.model});
}

class MainLoadingCompleted extends MainState {
  const MainLoadingCompleted({required super.model});
}

class MainGeneralError extends MainState {

  final String message;

  const MainGeneralError({required this.message, required super.model});

  @override
  List<Object?> get props => [...super.props, message];
  
}

class MainNoGeneralError extends MainState {
  const MainNoGeneralError({required super.model});
}