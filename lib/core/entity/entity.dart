import 'package:equatable/equatable.dart';

abstract class Entity extends Equatable {
  @override
  List<Object?> get props => [];
}

class NoEntity extends Entity {}