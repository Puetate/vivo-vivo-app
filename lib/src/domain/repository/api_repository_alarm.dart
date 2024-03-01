import 'package:vivo_vivo_app/src/domain/models/Request/alarm.dart';

abstract class ApiRepositoryAlarmInterface {
  Future postAlarm(AlarmRequest alarm);
  Future<bool> putAlarm(Map alarm);
  Future postAlarmDetail(AlarmDetail alarmDetail);
}
