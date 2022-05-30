import 'package:equatable/equatable.dart';

class Response extends Equatable{
  final String message;
  final dynamic data;

  const Response({
    required this.message,
    required this.data
  });

  @override
  List<Object?> get props => [message, data];
}