import 'package:vivo_vivo_app/src/domain/models/alarm.dart';

abstract class ApiRepositoryNotificationInterface {
  Future postAlarm(AlarmRequest alarm);
  Future<bool> putAlarm(Map alarm);
  Future<List<Alarm>> getAlertsByUser(String userId);
  Future<dynamic> getDevices();
  Future<bool> sendNotificationFamilyGroup(String userId, String name);
}
