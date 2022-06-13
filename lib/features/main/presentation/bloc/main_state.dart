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
  const MainInit() : super(model: const MainModel(currentPageIndex: 0));
}

class MainChanged extends MainState {
  const MainChanged({required super.model});
}