import 'package:equatable/equatable.dart';

class MainModel extends Equatable {
  
  final int currentPageIndex;

  const MainModel({
    required this.currentPageIndex
  });

  MainModel copyWith({int? currentPageIndex}) => MainModel(currentPageIndex: currentPageIndex ?? this.currentPageIndex);

  @override
  List<Object?> get props => [currentPageIndex];
  
}