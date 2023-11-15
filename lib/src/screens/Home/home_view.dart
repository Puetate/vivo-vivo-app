import 'dart:async';
import 'package:badges/badges.dart' as BG;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.Dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:vibration/vibration.dart';
import 'package:location/location.dart' as LC;
import 'package:vivo_vivo_app/src/commons/permissions.dart';
import 'package:vivo_vivo_app/src/data/datasource/mongo/api_repository_notification_impl.dart';
import 'package:vivo_vivo_app/src/domain/models/user_alert.dart';
import 'package:vivo_vivo_app/src/domain/models/user_pref_provider.dart';
import 'package:vivo_vivo_app/src/providers/alarm_state_provider.dart';
import 'package:vivo_vivo_app/src/providers/user_provider.dart';
import 'package:vivo_vivo_app/src/screens/Alerts/alerts.dart';
import 'package:vivo_vivo_app/src/screens/Home/components/drawer.dart';
import 'package:vivo_vivo_app/src/screens/Home/controllers/home_controller.dart';
import 'package:vivo_vivo_app/src/utils/app_layout.dart';
import 'package:vivo_vivo_app/src/utils/app_styles.dart';

class HomeView extends StatefulWidget {
  static const String id = 'home_view';

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late StreamSubscription<LC.LocationData> locationSubscription;
  late final HomeController homeController;
  late String idAlarm;
  late UserAuth user;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _inkWellKey = GlobalKey();
  final Key _key = const Key('ripple');

  ApiRepositoryNotificationImpl serviceAlert = ApiRepositoryNotificationImpl();
  TextEditingController password = TextEditingController();
  String passwordConfirm = "";
  String textButton = "Envío de alerta de Incidente";
  LC.Location location = LC.Location();
  bool isProcessSendLocation = false;
  List<String> familyGroupIds = [];
  List<UserAlert>? userAlerts = [];
  bool isSendLocation = false;
  int countSocket = 0;
  int count = 0;

  @override
  void initState() {
    super.initState();
    homeController = HomeController(context);
    homeController.openPreferences(context);
    user = context.read<UserProvider>().getUserPrefProvider!.getUser;
    homeController.initSocket(user);
    homeController.onStateGetAlerts =
        (userAlerts, count) => setUserAlerts(userAlerts, count);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.openStateUser(user);
    });
    homeController.getUsersAlerts();
    initPlatform(context);
    // onAlerts();
    // homeController.openPermissionLocations();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = AppLayout.getSize(context);
    AlarmStateProvider alarmProvider = context.watch<AlarmStateProvider>();
    // homeController.openPermissionLocations();

    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(color: Color.fromRGBO(56, 56, 76, 1)),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: size.height * 0.04, left: 1, bottom: 15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        key: _inkWellKey,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: BG.Badge(
                            badgeContent: Text("$count"),
                            badgeStyle: const BG.BadgeStyle(
                              padding: EdgeInsets.all(5.5),
                            ),
                            badgeAnimation: const BG.BadgeAnimation.slide(),
                            child: const Icon(Icons.notification_important,
                                size: 27, color: Colors.white),
                          ),
                        ),
                        onTap: () {
                          showBarModalBottomSheet(
                            context: context,
                            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            builder: (context) => Alerts(
                              userId: user.idUser,
                            ),
                          );
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          _scaffoldKey.currentState!.openEndDrawer();
                        },
                        icon: const Icon(Icons.menu, color: Colors.white),
                      ),
                    ]),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(alarmProvider.getTextButton,
                        style: Styles.textStyleBody),
                    if (!alarmProvider.getIsSendLocation) ...[
                      (!alarmProvider.getIsProcessSendLocation)
                          ? RawGestureDetector(
                              gestures: <Type, GestureRecognizerFactory>{
                                LongPressGestureRecognizer:
                                    GestureRecognizerFactoryWithHandlers<
                                        LongPressGestureRecognizer>(
                                  () => LongPressGestureRecognizer(
                                    debugOwner: this,
                                    duration: const Duration(seconds: 2),
                                  ),
                                  (LongPressGestureRecognizer instance) {
                                    instance.onLongPress = () {
                                      Vibration.vibrate(duration: 50);
                                      alarmProvider
                                          .setIsProcessSendLocation(true);
                                      sendLocation(true);
                                    };
                                  },
                                ),
                              },
                              child: Image(
                                image: const AssetImage("assets/image/sos.png"),
                                height: (size.width * 0.6),
                              ),
                            )
                          : RippleAnimation(
                              key: _key,
                              repeat: true,
                              color: Styles.redText,
                              minRadius: 140,
                              ripplesCount: 8,
                              child: Image(
                                image:
                                    const AssetImage("assets/image/alert.gif"),
                                height: (size.width * 0.6),
                              ),
                            ),
                      const Text(
                        "Presione durante 3 segundos para enviar alerta",
                        style: TextStyle(color: Colors.white),
                      )
                    ] else ...[
                      Center(
                        child: (!alarmProvider.getIsProcessFinalizeLocation)
                            ? Column(
                                children: [
                                  /*  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Styles.redText,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15,
                                            horizontal: size.height * 0.1),
                                      ),
                                      child: const Text("Cancelar"),
                                      onPressed: () {}), */
                                  const Gap(30),
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      ClipOval(
                                        child: Material(
                                          elevation: 20,
                                          child: Container(
                                            color: Colors.grey[350],
                                            child: SizedBox(
                                              width: size.width * 0.57,
                                              height: size.width * 0.57,
                                            ),
                                          ),
                                        ),
                                      ),
                                      ClipOval(
                                        child: Material(
                                            color: Styles.green, // Button color
                                            child: RawGestureDetector(
                                              gestures: <Type,
                                                  GestureRecognizerFactory>{
                                                LongPressGestureRecognizer:
                                                    GestureRecognizerFactoryWithHandlers<
                                                        LongPressGestureRecognizer>(
                                                  () =>
                                                      LongPressGestureRecognizer(
                                                    debugOwner: this,
                                                    duration: const Duration(
                                                        seconds: 2),
                                                  ),
                                                  (LongPressGestureRecognizer
                                                      instance) {
                                                    instance.onLongPress = () {
                                                      Vibration.vibrate(
                                                          duration: 50);
                                                      alarmProvider
                                                          .setIsProcessFinalizeLocation(
                                                              true);
                                                      (cancelSendLocation());
                                                    };
                                                  },
                                                ),
                                              },
                                              child: SizedBox(
                                                width: size.width * 0.55,
                                                height: size.width * 0.55,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.check_rounded,
                                                      size: (size.width * 0.2),
                                                    ),
                                                    Text(
                                                      "¡Ya Estoy Seguro!",
                                                      style: Styles
                                                          .textStyleTitle
                                                          .copyWith(
                                                              fontSize: 17),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            : Lottie.asset(
                                'assets/lottie/chargeIsSecurity.json',
                                width: size.width * 0.8,
                                height: size.height * 0.35,
                              ),
                      ),
                      const Text(
                        "Presione durante 3 segundos para terminar alerta",
                        style: TextStyle(color: Colors.white),
                      ),
                    ]
                  ],
                ),
              )
            ],
          ),
        ),
        endDrawer: EndDrawer(user: user));
  }

  void setUserAlerts(List<UserAlert>? newUserAlerts, int newCount) {
    setState(() {
      userAlerts = newUserAlerts;
      count = newCount;
    });
  }

  Future<void> initPlatform(BuildContext context) async {
    if (!mounted) return;
    homeController.initPlatform();
  }

  void onAlerts() {
    homeController.onAlerts();
  }

  void sendLocation(bool isNewAlarm) async {
    bool hasPermission = false;

    if (mounted) {
      hasPermission = await Permissions.checkPermission(context);
    }
    homeController.initSendAlarm(isNewAlarm, hasPermission, user);
  }

  void cancelSendLocation() async {
    homeController.cancelSendLocation(user.idUser);
  }
}
