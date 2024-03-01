import 'package:vivo_vivo_app/src/domain/api/vivo_vivo_api.dart';
import 'package:vivo_vivo_app/src/domain/models/Request/notification_family_group.dart';
import 'package:vivo_vivo_app/src/domain/models/Request/alarm.dart';
import 'package:vivo_vivo_app/src/domain/repository/api_repository_notification.dart';



class ApiRepositoryNotificationImpl extends ApiRepositoryNotificationInterface {
  @override
  Future<List<Alarm>> getAlertsByUser(String userId) {
    throw UnimplementedError();
  }

  @override
  Future getDevices() {
    throw UnimplementedError();
  }

  @override
  Future sendNotificationFamilyGroup(NotificationFamilyGroup notificationFamilyGroup) async {
    var res =
       await Api.post("push-notification/send-notification-family-group", notificationFamilyGroup.toJson());
    return res;
  }
}
