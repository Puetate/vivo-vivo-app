import 'dart:typed_data';

import 'package:vivo_vivo_app/src/domain/api/vivo_vivo_api.dart';
import 'package:vivo_vivo_app/src/domain/models/person.dart';
import 'package:vivo_vivo_app/src/domain/models/user.dart';
import 'package:vivo_vivo_app/src/domain/models/user_pref_provider.dart';
import 'package:vivo_vivo_app/src/domain/repository/api_repository.dart';

class ApiRepositoryUserImpl extends ApiRepositoryUserInterface {
  @override
  Future<Uint8List> getImageNetwork(String imgUrl) {
    throw UnimplementedError();
  }

  @override
  Future<UserPrefProvider?> getUser(Map<String, dynamic> credentials) async {
    var res = await Api.get("/api/user/login", credentials);
   
    return res;
  }

  @override
  Future<Map<String, dynamic>> postChangePassword(Map changePasswordData) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> postIdOneSignal(
      String id, String idOneSignal, String token) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> postSendEmailChangePassword(
      Map changePasswordData) {
    throw UnimplementedError();
  }

  @override
  Future<bool> putStateByUser(String userId, String state) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> saveUser(User user, Person person) {
    throw UnimplementedError();
  }
}
