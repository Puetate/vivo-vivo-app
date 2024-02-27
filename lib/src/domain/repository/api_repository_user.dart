import 'package:flutter/foundation.dart';
import 'package:vivo_vivo_app/src/domain/models/person.dart';
import 'package:vivo_vivo_app/src/domain/models/person_disability.dart';
import 'package:vivo_vivo_app/src/domain/models/person_info.dart';
import 'package:vivo_vivo_app/src/domain/models/user.dart';

abstract class ApiRepositoryUserInterface {
  Future getUser(Map<String, dynamic> credentials);
  Future postIdOneSignal(String id, String idOneSignal);
  Future saveUser(FamilyGroup user, Person person, PersonInfo personInfo,
      PersonDisability personDisability);
  Future postChangePassword(String id, Map<String, dynamic> changePasswordData);
  Future<Map<String, dynamic>> postSendEmailChangePassword(
      Map changePasswordData);
  Future<bool> putStateByUser(String userId, String state);
  Future<Uint8List> getImageNetwork(String imgUrl);
}
