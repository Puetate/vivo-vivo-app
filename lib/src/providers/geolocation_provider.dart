import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

class GeoLocationProvider with ChangeNotifier {
  LocationData? currentPosition;
  Location location = Location();
  LocationData locationData = LocationData.fromMap({});
  StreamSubscription<LocationData>? locationSubscription;

  LocationData get getLocationData => locationData;

  LocationData? get getCurrentPosition => currentPosition;

  Location get getLocation => location;

  StreamSubscription<LocationData>? get getLocationSubscription =>
      locationSubscription;

  Future<bool> getCurrentLocation() async {
    try {
      currentPosition = await location.getLocation();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  set setLocationData(LocationData value) {
    locationData = value;
    notifyListeners();
  }

  set setLocationSubscription(StreamSubscription<LocationData>? value) {
    locationSubscription = value;
    notifyListeners();
  }

  Future<void> stopListen() async {
    await locationSubscription?.cancel();
    locationSubscription = null;
    notifyListeners();
  }
}
