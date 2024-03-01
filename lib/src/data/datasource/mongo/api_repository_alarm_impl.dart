import 'package:vivo_vivo_app/src/domain/api/vivo_vivo_api.dart';
import 'package:vivo_vivo_app/src/domain/models/Request/alarm.dart';
import 'package:vivo_vivo_app/src/domain/repository/api_repository_alarm.dart';

class ApiRepositoryAlarmImpl extends ApiRepositoryAlarmInterface {
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
  Future postAlarmDetail(AlarmDetail alarmDetail) async {
    var res = await Api.post("alarm-detail-position", alarmDetail.toJson());
    return res;
  }
}
