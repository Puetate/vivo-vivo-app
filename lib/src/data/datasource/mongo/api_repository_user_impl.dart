import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:vivo_vivo_app/src/domain/api/vivo_vivo_api.dart';
import 'package:vivo_vivo_app/src/domain/models/person.dart';
import 'package:vivo_vivo_app/src/domain/models/person_disability.dart';
import 'package:vivo_vivo_app/src/domain/models/person_info.dart';
import 'package:vivo_vivo_app/src/domain/models/user.dart';
import 'package:vivo_vivo_app/src/domain/repository/api_repository_user.dart';

class ApiRepositoryUserImpl extends ApiRepositoryUserInterface {
  @override
  Future<Uint8List> getImageNetwork(String imgUrl) {
    throw UnimplementedError();
  }

  @override
  Future getUser(Map<String, dynamic> credentials) async {
    var res = await Api.post("auth/login/mobile", credentials);
    return res;
  }

  @override
  Future postChangePassword(
      String id, Map<String, dynamic> changePasswordData) async {
    var res = await Api.patch("auth/change-password/$id", changePasswordData);
    return res;
  }

  @override
  Future postIdOneSignal(String id, String idOneSignal) async {
    Map<String, dynamic> data = {
      "idOneSignal": idOneSignal,
    };
    var res = await Api.patch("user/$id", data);
    return res;
  }

  @override
  Future postSendEmailChangePassword(
      Map<String, dynamic> changePasswordData) async {
    var res = await Api.post("auth/recover-password", changePasswordData);
    return res;
  }

  @override
  Future<bool> putStateByUser(String userId, String state) {
    throw UnimplementedError();
  }

  @override
  Future saveUser(FamilyGroup user, Person person, PersonInfo personInfo,
      PersonDisability? personDisability) async {
    Map<String, String> userData = {
      "email": user.email,
      "password": user.password,
    };
    Map<String, dynamic> data;
    if (personDisability == null) {
      data = {
        'avatar': await MultipartFile.fromFile(person.avatar.path,
            filename: person.avatar.name),
        'user': userData,
        'person': person.toJson(),
        'personInfo': personInfo.toJson(),
      };
    } else {
      data = {
        'avatar': await MultipartFile.fromFile(person.avatar.path,
            filename: person.avatar.name),
        'user': userData,
        'person': person.toJson(),
        'personInfo': personInfo.toJson(),
        'personDisability': personDisability.toJson(),
      };
    }

    var res = await Api.postWithFile("auth/register", data);
    return res;
  }
}
