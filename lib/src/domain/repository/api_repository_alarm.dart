import 'package:vivo_vivo_app/src/domain/models/user_alert.dart';

abstract class ApiRepositoryAlarmInterface {
  Future<List<UserAlert>> getUsersAlertsByPerson(String personId);
}
