import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:location/location.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:vivo_vivo_app/src/commons/permissions.dart';
import 'package:vivo_vivo_app/src/commons/shared_preferences.dart';
import 'package:vivo_vivo_app/src/data/datasource/mongo/api_repository_family_group_impl.dart';
import 'package:vivo_vivo_app/src/data/datasource/mongo/api_repository_notification_impl.dart';
import 'package:vivo_vivo_app/src/data/datasource/mongo/api_repository_user_impl.dart';
import 'package:vivo_vivo_app/src/data/datasource/mongo/api_repository_alarm_impl.dart';
import 'package:vivo_vivo_app/src/domain/models/alarm.dart';
import 'package:vivo_vivo_app/src/domain/models/user.dart';
import 'package:vivo_vivo_app/src/domain/models/user_alert.dart';
import 'package:vivo_vivo_app/src/domain/models/user_pref_provider.dart';
import 'package:vivo_vivo_app/src/providers/alarm_state_provider.dart';
import 'package:vivo_vivo_app/src/providers/geolocation_provider.dart';
import 'package:vivo_vivo_app/src/providers/socket_provider.dart';
import 'package:vivo_vivo_app/src/providers/user_provider.dart';
import 'package:vivo_vivo_app/src/screens/Home/components/permission_dialog.dart';
import 'package:vivo_vivo_app/src/utils/snackbars.dart';

String EVENT = "update-alarms";
String DANGER = "DANGER";
String MOBILE = "MOBILE";

class HomeController {
  late final Function(List<UserAlert> userAlerts, int count) onStateGetAlerts;
  late ApiRepositoryNotificationImpl notificationService;
  late ApiRepositoryFamilyGroupImpl familyGroupService;
  late GeoLocationProvider geoLocationProvider;
  late AlarmStateProvider alarmState;
  late ApiRepositoryUserImpl userService;
  late SocketProvider socketProvider;
  late BuildContext context;

  HomeController({required BuildContext newContext}) {
    context = newContext;
    geoLocationProvider = context.read<GeoLocationProvider>();
    notificationService = ApiRepositoryNotificationImpl();
    familyGroupService = ApiRepositoryFamilyGroupImpl();
    alarmState = context.read<AlarmStateProvider>();
    userService = ApiRepositoryUserImpl();
  }

  Future<void> openPreferences(BuildContext contextt) async {
    try {
      String userString = SharedPrefs().user;
      String token = SharedPrefs().token;

      if (userString.isNotEmpty && token.isNotEmpty) {
        final UserAuth user = userAuthFromJson(userString);
        UserProvider userProvider = contextt.read<UserProvider>();
        await userProvider.getUser(user, token).then((value) => null);
      } else {
        return;
      }
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<void> initPlatform() async {
    OneSignal.initialize(dotenv.env['API_ONE_SIGNAL']!);
    OneSignal.User.pushSubscription.addObserver((state) {
      // print(OneSignal.User.pushSubscription.optedIn);
      print(OneSignal.User.pushSubscription.id);
      // print(OneSignal.User.pushSubscription.token);
      print(state.current.jsonRepresentation());
      setIdOneSignal(OneSignal.User.pushSubscription.id!);
    });
    OneSignal.InAppMessages.addClickListener((event) {
      print(
          "In App Message Clicked: \n${event.result.jsonRepresentation().replaceAll("\\n", "\n")}");
    });
  }

  Future<void> setIdOneSignal(String idOS) async {
    UserAuth user = context.read<UserProvider>().getUserPrefProvider!.getUser;
    if (user.idOneSignal == null || (user.idOneSignal != idOS)) {
      Map idOne = await userService.postIdOneSignal(user.idUser, idOS);
      //TODO: handle error
      user.idOneSignal = idOne["idOneSignal"];
      var userString = userAuthToJson(user);
      SharedPrefs().user = userString;
      return;
    }
  }

  void initSocket(UserAuth user) async {
    socketProvider = context.watch<SocketProvider>();
    socketProvider.connect(user);
  }

  void onAlerts() {
    UserAuth user = context.read<UserProvider>().getUserPrefProvider!.getUser;

    socketProvider.onAlerts("$EVENT-${user.idPerson}", (_) {
      getUsersAlerts();
    });
  }

  void getUsersAlerts() async {
    ApiRepositoryAlarmImpl serviceAlert = ApiRepositoryAlarmImpl();
    UserAuth user = context.read<UserProvider>().getUserPrefProvider!.getUser;

    List<UserAlert> users =
        await serviceAlert.getUsersAlertsByPerson(user.idPerson);

    int count = users.where((userAlert) => userAlert.state == DANGER).length;
    onStateGetAlerts(users, count);
  }

  void openStateUser(UserAuth user) async {
    String state = SharedPrefs().state;
    if (state == DANGER) {
      sendLocation(false, false, user);
    } else {
      var alarmProvider = context.read<AlarmStateProvider>();
      alarmProvider.setIsSendLocation(false);
      alarmProvider.setTextButton("Envío de alerta de Incidente");
    }
  }

  void sendLocation(bool isNewAlarm, bool hasPermission, UserAuth user) async {
    var alarmProvider = context.read<AlarmStateProvider>();

    bool isSendPosition =
        await getLivePosition(isNewAlarm, hasPermission, user);
    if (isSendPosition) {
      Vibration.vibrate(duration: 1000);
      alarmProvider.setIsProcessSendLocation(false);
      alarmProvider.setIsSendLocation(true);
      alarmProvider.setTextButton("Se esta enviando tu ubicación...");

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(MySnackBars.successSnackBar);
      await notificationService.sendNotificationFamilyGroup(
          user.idUser, "${user.username} ${user.username}");
    } else {
      alarmProvider.setIsProcessSendLocation(false);
    }
  }

  Future<bool> getLivePosition(
      bool isNewAlarm, bool hasPermission, UserAuth user) async {
    double lng = 0;
    double lat = 0;
    if (hasPermission) {
      if (isNewAlarm) {
        await geoLocationProvider.getCurrentLocation();
        lng = geoLocationProvider.getCurrentPosition!.longitude!;
        lat = geoLocationProvider.getCurrentPosition!.latitude!;
        String idAlarm = await postAlarmBD(lat, lng, user);
        SharedPrefs().idAlarm = idAlarm;
      }
      getFamilyGroup(isNewAlarm, user);
      SharedPrefs().state = DANGER;
      startListeningPosition();
      return true;
    } else {
      openPermissionLocations();
      return false;
    }
  }

  void startListeningPosition() {
    var location = geoLocationProvider.getLocation;
    location.enableBackgroundMode(enable: true);
    location.changeNotificationOptions(
        channelName: "channel",
        subtitle: "Se esta enviando tu ubicación a tu núcleo de confianza.",
        description: "desc",
        title: "Vivo Vivo está accediendo a su ubicación",
        color: Colors.red);
    var locationSubscription =
        location.onLocationChanged.listen((LocationData position) {
      log('${position.latitude}, ${position.longitude}');

      Map data = {
        "position": {"lat": position.latitude, "lng": position.longitude},
        "familyGroup": jsonDecode(SharedPrefs().familyGroupIds).cast<String>()
      };
      geoLocationProvider.setLocationData = position;
      socketProvider.emitLocation("send-alarm", jsonEncode(data));
    });
    geoLocationProvider.setLocationSubscription = locationSubscription;
  }

  Future<String> postAlarmBD(double lat, double lng, UserAuth user) async {
    AlarmRequest alarmRequest = AlarmRequest(
      alarm: Alarm(
        user: user.idUser,
        alarmType: MOBILE,
      ),
      alarmDetail: AlarmDetail(
          alarmStatus: DANGER,
          date: DateTime.now(),
          latitude: lat,
          longitude: lng),
    );
    var res = await notificationService.postAlarm(alarmRequest);
    if (res == null || res.error) return '';
    final Alarm alarm = Alarm.fromJson(res.data);
    return alarm.id!;
  }

  void getFamilyGroup(bool isNewAlert, UserAuth user) async {
    List<User> users =
        await familyGroupService.getFamilyGroupByUser(user.idUser);
    List<String> familyGroupIds = [];
    if (isNewAlert) {
      familyGroupIds.clear();
      users.forEach((user) {
        familyGroupIds.add(user.person!.id!);
      });
      SharedPrefs().familyGroupIds = jsonEncode(familyGroupIds);
    } else {
      familyGroupIds.clear();
      String codeList = SharedPrefs().familyGroupIds;
      familyGroupIds = jsonDecode(codeList).cast<String>();
    }
  }

  Future<void> openPermissionLocations() async {
    bool isPermissionEnable = await Permissions.checkPermission(context);
    if (!isPermissionEnable) {
      SchedulerBinding.instance.addPostFrameCallback((_) => showDialog(
          context: context,
          builder: ((context) {
            return PermissionLocation();
          })));
    }
  }

  void logOut() async {
    SharedPrefs().logout();
    Navigator.of(context).pushReplacementNamed("/");
    var userProvider = context.read<UserProvider>();
    userProvider.resetUser();
  }
}
