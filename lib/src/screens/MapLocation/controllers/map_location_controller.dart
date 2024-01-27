import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:vivo_vivo_app/src/providers/geolocation_provider.dart';
import 'package:vivo_vivo_app/src/screens/Home/components/permission_dialog.dart';

class MapLocationController {
  late BuildContext context;
  late GeoLocationProvider geoLocationProvider;

  MapLocationController({required this.context}) {
    geoLocationProvider = context.read<GeoLocationProvider>();
  }

  void getLivePosition() {
    var location = geoLocationProvider.getLocation;
    // location.enableBackgroundMode(enable: false);
    location.changeSettings(accuracy: LocationAccuracy.high, distanceFilter: 0, interval: 400);
    location.changeNotificationOptions(
        channelName: "channel",
        subtitle: "Se esta enviando tu ubicación a tu núcleo de confianza.",
        description: "desc",
        title: "Vivo Vivo está accediendo a su ubicación",
        color: Colors.red);
    //geoLocationProvider.setIsSendLocation = true;
    var locationSubscription =
        location.onLocationChanged.listen((LocationData position) {
      log('${position.latitude} mia, ${position.longitude}');

      geoLocationProvider.setLocationData = position;
    });
    geoLocationProvider.setLocationSubscription = locationSubscription;
  }

  Future<void> openPermissionLocations() async {
    SchedulerBinding.instance.addPostFrameCallback((_) => showDialog(
        context: context,
        builder: ((context) {
          return PermissionLocation();
        })));
  }

  void cancelSendLocation() async {
    geoLocationProvider.stopListen();
  }
}
