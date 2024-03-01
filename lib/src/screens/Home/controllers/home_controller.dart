import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:location/location.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:vivo_vivo_app/src/commons/shared_preferences.dart';
import 'package:vivo_vivo_app/src/data/datasource/mongo/api_repository_family_group_impl.dart';
import 'package:vivo_vivo_app/src/data/datasource/mongo/api_repository_notification_impl.dart';
import 'package:vivo_vivo_app/src/data/datasource/mongo/api_repository_user_impl.dart';
import 'package:vivo_vivo_app/src/data/datasource/mongo/api_repository_alarm_impl.dart';
import 'package:vivo_vivo_app/src/domain/models/Request/notification_family_group.dart';
import 'package:vivo_vivo_app/src/domain/models/Request/alarm.dart';
import 'package:vivo_vivo_app/src/domain/models/user_alert.dart';
import 'package:vivo_vivo_app/src/domain/models/user_auth.dart';
import 'package:vivo_vivo_app/src/providers/alarm_state_provider.dart';
import 'package:vivo_vivo_app/src/providers/geolocation_provider.dart';
import 'package:vivo_vivo_app/src/providers/socket_provider.dart';
import 'package:vivo_vivo_app/src/providers/user_provider.dart';
import 'package:vivo_vivo_app/src/screens/Home/components/permission_dialog.dart';
import 'package:vivo_vivo_app/src/utils/snackbars.dart';

String EVENT = "update-user-status";
String DANGER = "DANGER";
String MOBILE = "MOBILE";
String OK = "OK";
typedef FunctionStart = void Function();

class HomeController {
  late final Function(List<UserAlert>? userAlerts, int count) onStateGetAlerts;
  late ApiRepositoryNotificationImpl notificationService;
  late ApiRepositoryFamilyGroupImpl familyGroupService;
  late GeoLocationProvider geoLocationProvider;
  late ApiRepositoryAlarmImpl alarmService;
  late AlarmStateProvider alarmState;
  late ApiRepositoryUserImpl userService;
  late SocketProvider socketProvider;
  late BuildContext context;

  HomeController(BuildContext newContext) {
    context = newContext;
    geoLocationProvider = context.read<GeoLocationProvider>();
    notificationService = ApiRepositoryNotificationImpl();
    familyGroupService = ApiRepositoryFamilyGroupImpl();
    alarmState = context.read<AlarmStateProvider>();
    alarmService = ApiRepositoryAlarmImpl();
    userService = ApiRepositoryUserImpl();
    socketProvider = context.read<SocketProvider>();
  }

  Future<void> openPreferences(BuildContext context) async {
    try {
      String userString = SharedPrefs().user;
      String token = SharedPrefs().token;

      if (userString.isEmpty && token.isEmpty) return;

      final UserAuth user = userAuthFromJsonPreferences(userString);
      UserProvider userProvider = context.read<UserProvider>();
      userProvider.getUser(user, token);
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<void> initPlatform() async {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(dotenv.env['API_ONE_SIGNAL']!);
    OneSignal.Notifications.requestPermission(true);
    OneSignal.User.pushSubscription.addObserver((state) {
      print(state.current.jsonRepresentation());
      setIdOneSignal(OneSignal.User.pushSubscription.id!);
    });
    OneSignal.Notifications.addPermissionObserver((state) {
      print("Has permission " + state.toString());
    });
    OneSignal.InAppMessages.addClickListener((event) {
      print(
          "In App Message Clicked: \n${event.result.jsonRepresentation().replaceAll("\\n", "\n")}");
    });
  }

  void handleConsent() {
    print("Setting consent to true");
    OneSignal.consentGiven(true);

    print("Setting state");
  }

  Future<void> setIdOneSignal(String idOS) async {
    UserAuth user = context.read<UserProvider>().getUserPrefProvider!.getUser;
    if (user.idOneSignal == null || (user.idOneSignal != idOS)) {
      var res = await userService.postIdOneSignal(user.userID.toString(), idOS);
      if (res == null || res.error) {
        OneSignal.logout();
        return;
      }
      user.idOneSignal = res.data["oneSignalID"];
      var userString = userAuthToJson(user);
      SharedPrefs().user = userString;
      return;
    }
  }

  void initSocket(UserAuth user) async {
    socketProvider.connect(user);
  }

  void onAlerts(Function startSomething) {
    UserAuth user = context.read<UserProvider>().getUserPrefProvider!.getUser;

    socketProvider.onAlerts("$EVENT-${user.userID}", (_) {
      startSomething();
    });
  }

  void getUsersAlerts() async {
    UserAuth user = context.read<UserProvider>().getUserPrefProvider!.getUser;

    var res = await familyGroupService
        .getFamilyGroupByUserInDanger(user.userID.toString());
    if (res == null || res.error) return;
    int count = res.data["count"];
    onStateGetAlerts(null, count);
  }

  void openStateUser(UserAuth user) async {
    String state = SharedPrefs().state;
    if (state == DANGER) {
      alarmState.setIsProcessSendLocation(true);
      initSendAlarm(false, true, user);
    } else {
      var alarmProvider = context.read<AlarmStateProvider>();
      alarmProvider.setIsSendLocation(false);
      alarmProvider.setTextButton("Envío de alerta de Incidente");
    }
  }

  void initSendAlarm(bool isNewAlarm, bool hasPermission, UserAuth user) async {
    bool isSendPosition = await startAlarm(isNewAlarm, hasPermission, user);
    if (!isSendPosition) {
      alarmState.setIsProcessSendLocation(false);
      return;
    }
    NotificationFamilyGroup notificationFamilyGroup =
        NotificationFamilyGroup(userID: user.userID, names: user.names);
    await notificationService
        .sendNotificationFamilyGroup(notificationFamilyGroup);
    alarmState.setIsSendLocation(true);
    alarmState.setTextButton("Se esta enviando tu ubicación...");
    Vibration.vibrate(duration: 1000);

    ScaffoldMessenger.of(context).showSnackBar(MySnackBars.successSnackBar(
        "Tu alarma ha sido enviada con éxito.", "¡Excelentes noticias!"));
  }

  Future<bool> startAlarm(
      bool isNewAlarm, bool hasPermission, UserAuth user) async {
    double lng = 0;
    double lat = 0;
    if (!hasPermission) {
      openPermissionLocations();
      return false;
    }
    if (isNewAlarm) {
      await geoLocationProvider.getCurrentLocation();
      lng = geoLocationProvider.getCurrentPosition!.longitude!;
      lat = geoLocationProvider.getCurrentPosition!.latitude!;
      int idAlarm = await postAlarmBD(lat, lng, user);
      if (idAlarm.isNegative) return false;
      SharedPrefs().idAlarm = idAlarm;
      await getFamilyGroup(isNewAlarm, user);
      SharedPrefs().state = DANGER;
    }

    getLivePosition(user);
    return true;
  }

  void getLivePosition(UserAuth user) {
    var location = geoLocationProvider.getLocation;
    location.enableBackgroundMode(enable: true);
    location.changeSettings(
        accuracy: LocationAccuracy.high, distanceFilter: 0, interval: 400);
    location.changeNotificationOptions(
        channelName: "channel",
        subtitle: "Se esta enviando tu ubicación a tu núcleo de confianza.",
        description: "desc",
        title: "Vivo Vivo está accediendo a su ubicación",
        color: Colors.red,
        onTapBringToFront: true);
    geoLocationProvider.setIsSendLocation = true;
    if (SharedPrefs().familyGroupIds.isEmpty) return;
    var familyGroupsIds = jsonDecode(SharedPrefs().familyGroupIds).cast<int>();
    var locationSubscription =
        location.onLocationChanged.listen((LocationData position) {
      Map data = {
        "position": {"lat": position.latitude, "lng": position.longitude},
        "familyMemberUserIds": familyGroupsIds,
        "userID": user.userID
      };
      geoLocationProvider.setLocationData = position;
      socketProvider.emitLocation("send-alarm", data);
      log('${position.latitude}, ${position.longitude}');
    });
    geoLocationProvider.setLocationSubscription = locationSubscription;
  }

  Future<int> postAlarmBD(double lat, double lng, UserAuth user) async {
    AlarmRequest alarmRequest = AlarmRequest(
      alarm: Alarm(
        userID: user.userID,
        alarmType: MOBILE,
      ),
      alarmDetail:
          AlarmDetail(alarmStatus: DANGER, latitude: lat, longitude: lng),
    );
    var res = await alarmService.postAlarm(alarmRequest);
    if (res == null || res.error) return -0;
    final Alarm alarm = Alarm.fromJson(res.data);
    return alarm.alarmID!;
  }

  Future<void> getFamilyGroup(bool isNewAlert, UserAuth user) async {
    if (isNewAlert) {
      var res = await familyGroupService
          .getFamilyMembersByUser(user.userID.toString());
      if (res == null || res.error) return;

      List<int> familyGroupIds = [];
      familyGroupIds = res.data.cast<int>();
      SharedPrefs().familyGroupIds = jsonEncode(familyGroupIds);
    }
  }

  Future<void> openPermissionLocations() async {
    SchedulerBinding.instance.addPostFrameCallback((_) => showDialog(
        context: context,
        builder: ((context) {
          return PermissionLocation();
        })));
  }

  void cancelViewLocation() {
    geoLocationProvider.stopListen();
  }

  void cancelSendLocation(int userId) async {
    geoLocationProvider.stopListen();
    await geoLocationProvider.getCurrentLocation();
    // location.enableBackgroundMode(enable: false);
    AlarmDetail alarmDetail = AlarmDetail(
      alarmID: SharedPrefs().idAlarm,
      alarmStatus: OK,
      latitude: geoLocationProvider.locationData.latitude!,
      longitude: geoLocationProvider.locationData.longitude!,
      userID: userId,
    );
    var res = await alarmService.postAlarmDetail(alarmDetail);
    if (res == null || res.error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No se pudo cancelar, Intente de nuevo'),
      ));
      alarmState.setIsProcessFinalizeLocation(false);
      return;
    }
    SharedPrefs().state = OK;
    SharedPrefs().removeAlarmInfo();
    alarmState.setIsProcessSendLocation(false);
    alarmState.setIsProcessFinalizeLocation(false);
    alarmState.setIsSendLocation(false);
    alarmState.setTextButton("Envío de alerta de Incidente");
    Vibration.vibrate(duration: 100);
  }

  void logOut() async {
    SharedPrefs().logout();
    Navigator.of(context).pushReplacementNamed("/");
    var userProvider = context.read<UserProvider>();
    userProvider.resetUser();
  }
}
