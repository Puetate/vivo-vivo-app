import 'package:vivo_vivo_app/src/domain/models/Request/notification_family_group.dart';
import 'package:vivo_vivo_app/src/domain/models/Request/alarm.dart';

abstract class ApiRepositoryNotificationInterface {
  Future<List<Alarm>> getAlertsByUser(String userId);
  Future<dynamic> getDevices();
  Future sendNotificationFamilyGroup(NotificationFamilyGroup notificationFamilyGroup);
}
