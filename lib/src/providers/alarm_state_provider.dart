import 'package:flutter/material.dart';

class AlarmStateProvider with ChangeNotifier {
  bool isSendLocation = false;
  bool isProcessSendLocation = false;
  bool isProcessFinalizeLocation = false;
  String textButton = "Envío de alerta de Incidente";

  bool get getIsSendLocation => isSendLocation;
  bool get getIsProcessSendLocation => isProcessSendLocation;
  bool get getIsProcessFinalizeLocation => isProcessFinalizeLocation;
  String get getTextButton => textButton;

  void setIsSendLocation(bool value) {
    isSendLocation = value;
    notifyListeners();
  }

  void setIsProcessSendLocation(bool value) {
    isProcessSendLocation = value;
    notifyListeners();
  }

  void setIsProcessFinalizeLocation(bool value) {
    isProcessFinalizeLocation = value;
    notifyListeners();
  }

  void setTextButton(String value) {
    textButton = value;
    notifyListeners();
  }
}
