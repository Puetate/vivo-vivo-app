import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vivo_vivo_app/src/domain/api/dio.config.dart';

import 'package:vivo_vivo_app/src/global/global_variable.dart';
import 'package:vivo_vivo_app/src/utils/snackbars.dart';

class ResponseResult<T> {
  final T? data;
  final Object? error;

  ResponseResult({this.data, this.error});
}

class Api {
  static final Dio _dio = DioSingleton.getInstance();

  static Future<ResponseResult> httpGet(String path) async {
    return await _dio
        .get(
          path,
        )
        .then((value) => (ResponseResult(data: value.data, error: false)))
        .catchError((err) => (ResponseResult(data: '', error: true)))
        .onError((error, stackTrace) =>
            (ResponseResult(data: null, error: error ?? '')));
  }

  static Future get(String path, Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);

    return await _dio
        .get(
          path,
          data: formData,
        )
        .then((value) => (ResponseResult(data: value.data, error: null)))
        .catchError((err) => (ResponseResult(data: '', error: true)))
        .onError(
            (error, stackTrace) => (ResponseResult(data: null, error: error)));
  }

  static Future<ResponseResult> post(
      String path, Map<String, dynamic> data) async {
    return await _dio
        .post(path, data: data)
        .then((value) => (ResponseResult(data: value.data, error: false)))
        .catchError((err) => (ResponseResult(data: '', error: true)))
        .onError((error, stackTrace) =>
            (ResponseResult(data: null, error: error ?? '')));
  }

  static Future postWithFile(String path, Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data, ListFormat.pipes);
    return await _dio
        .post(path, data: formData)
        .then((value) => (ResponseResult(data: value.data, error: false)))
        .catchError((err) => (ResponseResult(data: '', error: true)))
        .onError(
            (error, stackTrace) => (ResponseResult(data: null, error: true)));
  }

  static Future patch(String path, Map<String, dynamic> data) async {
    return await _dio
        .patch(path, data: data)
        .then((value) => (ResponseResult(data: value.data, error: false)))
        .catchError((err) => (ResponseResult(data: '', error: true)))
        .onError(
            (error, stackTrace) => (ResponseResult(data: null, error: true)));
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

  static void checkException(DioException e) {
    String message = e.response!.data['error'];
    ScaffoldMessenger.of(GlobalVariable.navigatorState.currentContext!)
        .showSnackBar(MySnackBars.failureSnackBar(message, "Error!"));
  }

  void g() {}
}
