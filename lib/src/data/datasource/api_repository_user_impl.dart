import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:vivo_vivo_app/src/domain/api/vivo_vivo_api.dart';
import 'package:vivo_vivo_app/src/domain/models/person.dart';
import 'package:vivo_vivo_app/src/domain/models/person_disability.dart';
import 'package:vivo_vivo_app/src/domain/models/person_info.dart';
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
    var res = await Api.post("auth/login/mobile", credentials);

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
  Future<Map<String, dynamic>> saveUser(User user, Person person,
      PersonInfo personInfo, PersonDisability? personDisability) async {
    Map<String, String> userData = {
      "username": user.username,
      "email": user.email,
      "password": user.password,
    };
    Map<String, dynamic> data = {
      'avatar':
          await MultipartFile.fromFile(person.avatar, filename: person.avatar),
      'user': userData,
      'person': person.toJson(),
      'personInfo': personInfo.toJson(),
      'personDisability':
          (personDisability != null) ? personDisability.toJson() : null,
    };
    var res = await Api.postWithFile("auth/register", data);
    return res;
  }
}
