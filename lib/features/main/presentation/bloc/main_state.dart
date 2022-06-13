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