import 'package:vivo_vivo_app/src/domain/api/vivo_vivo_api.dart';
import 'package:vivo_vivo_app/src/domain/models/alarm.dart';
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
  Future sendNotificationFamilyGroup(String userId, String name) async {
    Map<String, dynamic> data = {
      "user": userId,
      "names": name,
    };
    var res =
       await Api.post("push-notification/send-notification-family-group", data);
    return res;
  }
}
