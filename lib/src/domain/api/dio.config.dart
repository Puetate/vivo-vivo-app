import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vivo_vivo_app/src/commons/shared_preferences.dart';
import 'package:vivo_vivo_app/src/global/global_variable.dart';
import 'package:vivo_vivo_app/src/utils/snackbars.dart';

class DioSingleton {
  static Dio? _instance;

  DioSingleton._internal() {
    // Configuración de Dio y sus interceptores
    final dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['BASE_URL']!,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
        },
        receiveTimeout: const Duration(seconds: 10)
      ),
    );

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = SharedPrefs()
            .token; // Implementa tu propia lógica para obtener el token
        options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
      onResponse: (response, handler) {
        handler.next(response);
      },
      onError: (DioException error, handler) {
        final message = error.response?.data['error'] ?? '';

        ScaffoldMessenger.of(GlobalVariable.navigatorState.currentContext!)
            .showSnackBar(MySnackBars.failureSnackBar(message,
                "Error!")); // Implementa tu propia lógica para mostrar mensajes de error
        handler.next(error);
      },
    ));

    _instance = dio;
  }

  static Dio getInstance() {
    if (_instance == null) {
      DioSingleton._internal(); // Crear una instancia si es nula
    }
    return _instance!;
  }
}
