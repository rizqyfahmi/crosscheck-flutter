import 'package:equatable/equatable.dart';

abstract class Param extends Equatable {
  @override
  List<Object?> get props => [];
}

class NoParam extends Param {}