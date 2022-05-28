abstract class Response {
  final String message;
  final Map<String, dynamic> data;

  Response({
    required this.message,
    required this.data
  });
}