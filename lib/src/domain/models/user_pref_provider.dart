import 'package:vivo_vivo_app/src/domain/models/user.dart';

class UserPrefProvider {
  User user;
  String token;
  UserPrefProvider({required this.user, required this.token});

  User get getUser => user;
  String get getToken => token;

  set setUser(User user) => this.user = user;
  set setToken(String token) => this.token = token;

}
