import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

import 'package:vivo_vivo_app/src/global/global_variable.dart';
import 'package:vivo_vivo_app/src/utils/snackbars.dart';

class Api {
  static final Dio _dio = Dio();
  static void configureDio() async {
    _dio.options.baseUrl = dotenv.env['BASE_URL']!;
    _dio.options.headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };
  }

  static Future httpGet(String path) async {
    try {
      final resp = await _dio.get(
        path,
      );

      return resp.data;
    } catch (e) {
      ScaffoldMessenger.of(GlobalVariable.navigatorState.currentContext!)
          .showSnackBar(MySnackBars.errorConnectionSnackBar());
    }
  }

  static Future post(String path, Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);

    try {
      final resp = await _dio.post(path, data: formData);
      return resp.data;
    } catch (e) {
      ScaffoldMessenger.of(GlobalVariable.navigatorState.currentContext!)
          .showSnackBar(MySnackBars.errorConnectionSnackBar());
    }
  }

  static Future put(String path, Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);

    try {
      final resp = await _dio.put(path, data: formData);
      return resp.data;
    } catch (e) {
      ScaffoldMessenger.of(GlobalVariable.navigatorState.currentContext!)
          .showSnackBar(MySnackBars.errorConnectionSnackBar());
    }
  }

  static Future delete(String path, Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);

    try {
      final resp = await _dio.delete(path, data: formData);
      return resp.data;
    } catch (e) {
      ScaffoldMessenger.of(GlobalVariable.navigatorState.currentContext!)
          .showSnackBar(MySnackBars.errorConnectionSnackBar());
    }
  }
}
