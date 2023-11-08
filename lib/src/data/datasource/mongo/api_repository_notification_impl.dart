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
  Future postAlarm(AlarmRequest alarm) async {
    var resp = await Api.post("alarm", alarm.toJson());
    return resp;
  }

  @override
  Future<bool> putAlarm(Map alarm) {
    throw UnimplementedError();
  }

  @override
  Future<bool> sendNotificationFamilyGroup(String userId, String name) {
    throw UnimplementedError();
  }
}
