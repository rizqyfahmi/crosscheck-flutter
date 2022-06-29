import 'package:crosscheck/core/param/param.dart';

class ProfileParams extends Param {
  final String token;

  ProfileParams({
    required this.token
  });

  @override
  List<Object?> get props => [token];
}