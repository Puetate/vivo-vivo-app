import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

class GeoLocationProvider with ChangeNotifier {
  LocationData? currentPosition;
  Location location = Location();
  
  bool isSendLocation = false;
  LocationData locationData = LocationData.fromMap({"latitude": 0.0, "longitude": 0.0});
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

  set setIsSendLocation(bool value) {
    isSendLocation = value;
    notifyListeners();
  }

  Future<void> stopListen() async {
    await locationSubscription?.cancel();
    isSendLocation = false;
    locationSubscription = null;
    notifyListeners();
  }
}
