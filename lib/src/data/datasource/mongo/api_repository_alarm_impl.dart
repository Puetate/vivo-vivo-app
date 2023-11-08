import 'package:vivo_vivo_app/src/domain/models/user_alert.dart';
import 'package:vivo_vivo_app/src/domain/repository/api_repository_alarm.dart';

class ApiRepositoryAlarmImpl extends ApiRepositoryAlarmInterface {
  @override
  Future<List<UserAlert>> getUsersAlertsByPerson(String personId) {
    throw UnimplementedError();
  }
  
}