import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class TaskCalendarModel extends Equatable {

  final String label;
  final DateTime? value;
  final Color color;

  const TaskCalendarModel({
    required this.label,
    required this.color,
    this.value
  });
  
  @override
  List<Object?> get props => [label, value, color];

}