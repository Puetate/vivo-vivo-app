import 'package:flutter/foundation.dart';
import 'package:vivo_vivo_app/src/domain/models/person.dart';
import 'package:vivo_vivo_app/src/domain/models/user.dart';
import 'package:vivo_vivo_app/src/domain/models/user_pref_provider.dart';

abstract class ApiRepositoryUserInterface {
  Future<UserPrefProvider?> getUser(Map<String, dynamic> credentials);
  Future<Map<String, dynamic>> postIdOneSignal(
      String id, String idOneSignal, String token);
  Future<Map<String, dynamic>> saveUser(User user, Person person);
  Future<Map<String, dynamic>> postChangePassword(Map changePasswordData);
  Future<Map<String, dynamic>> postSendEmailChangePassword(
      Map changePasswordData);
  Future<bool> putStateByUser(String userId, String state);
  Future<Uint8List> getImageNetwork(String imgUrl);
}
