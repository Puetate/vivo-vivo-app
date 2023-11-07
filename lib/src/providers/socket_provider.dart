import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:vivo_vivo_app/src/domain/models/user.dart';

class SocketProvider {
  late IO.Socket _socket;
  void connect(User user) async {
    try {
      if (_socket.connected) {
        return;
      }
      _socket = IO.io(
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
              .setQuery({'personId': user.person!.id})
              .setExtraHeaders({'personId': user.person!.id}) // optional
              .build());

      _socket.connect();
      _socket.onConnect((data) => {debugPrint("Conectado. ${_socket.id}")});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void disconnect() {
    _socket.disconnect();
  }

  void emitLocation(String event, [dynamic data]) {
    _socket.emit(event, data);
  }

  void onLocation(String event, dynamic Function(dynamic) callback) {
    _socket.on(event, callback);
  }

  void onAlerts(String event, dynamic Function(dynamic) callback) {
    _socket.on(event, callback);
  }
}
