import 'package:vivo_vivo_app/src/domain/models/alarm.dart';

abstract class ApiRepositoryNotificationInterface {
  Future<List<Alarm>> getAlertsByUser(String userId);
  Future<dynamic> getDevices();
  Future sendNotificationFamilyGroup(String userId, String name);
}
