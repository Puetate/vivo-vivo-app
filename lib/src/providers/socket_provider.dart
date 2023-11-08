import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:vivo_vivo_app/src/domain/models/user_pref_provider.dart';

class SocketProvider with ChangeNotifier {
  static late IO.Socket? _socket;

  // Declarar una instancia privada como parte del patrón Singleton.

  factory SocketProvider() => SocketProvider._internal();

  SocketProvider._internal();
  
  void connect(UserAuth user) async {
    try {
      if (_socket!.connected) {
        return;
      }
      _socket ??= IO.io(
          dotenv.env['BASE_URL'],
          /* <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
        'query': {"personId": user.person.id}
      } */
          IO.OptionBuilder()
              .setTransports(['websocket'])
              .enableAutoConnect()
              .enableReconnection()
              .setQuery({'personId': user.idPerson})
              .setExtraHeaders({'personId': user.idPerson}) // optional
              .build());

      _socket!.connect();
      _socket!.onConnect((data) => {debugPrint("Conectado. ${_socket!.id}")});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void disconnect() {
    _socket!.disconnect();
    notifyListeners();
  }

  void emitLocation(String event, [dynamic data]) {
    _socket!.emit(event, data);
    notifyListeners();

  }

  void onLocation(String event, dynamic Function(dynamic) callback) {
    _socket!.on(event, callback);
    notifyListeners();
  }

  void onAlerts(String event, dynamic Function(dynamic) callback) {
    _socket!.on(event, callback);
    notifyListeners();
  }
}
