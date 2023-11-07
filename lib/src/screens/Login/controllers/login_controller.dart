import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivo_vivo_app/src/commons/create_credentials.dart';
import 'dart:convert';

import 'package:vivo_vivo_app/src/commons/shared_preferences.dart';
import 'package:vivo_vivo_app/src/data/datasource/api_repository_user_impl.dart';
import 'package:vivo_vivo_app/src/domain/models/user.dart';
// import 'package:vivo_vivo_app/src/global/global_variable.dart';
import 'package:vivo_vivo_app/src/providers/user_provider.dart';
import 'package:vivo_vivo_app/src/screens/Home/home_view.dart';
// import 'package:vivo_vivo_app/src/utils/snackbars.dart';

class LoginController {
  late final Function(bool state) onStateConnect;
  late ApiRepositoryUserImpl userService;

  LoginController() {
    userService = ApiRepositoryUserImpl();
  }

  Future<void> showHomePage(BuildContext context, String userName,
      String password, bool saveCredentials) async {
    try {
      UserProvider userProvider = context.read<UserProvider>();
      var userData =
          await userService.getUser(createCredentials(userName, password));
      if (userData == null) {
        // ScaffoldMessenger.of(GlobalVariable.navigatorState.currentContext!)
        //     .showSnackBar(MySnackBars.errorConnectionSnackBar());
        onStateConnect(false);
        return;
        /* ScaffoldMessenger.of(context).showSnackBar(MySnackBars.failureSnackBar(
            'Usuario o Contraseña Incorrecta.\nPor favor intente de nuevo!',
            'Incorrecto!')); */
      }
      await userProvider.setUser(userData.getUser, userData.getToken);
      if (saveCredentials) (userData.getUser, userData.getToken);
      Navigator.of(context).pushReplacementNamed(HomeView.id);
    } catch (e) {
      print(e);
      onStateConnect(false);
      // ScaffoldMessenger.of(GlobalVariable.navigatorState.currentContext!)
      //     .showSnackBar(MySnackBars.errorConnectionSnackBar());
    }
  }

  Future<void> openPreferences(context) async {
    try {
      UserProvider userProvider = context.read<UserProvider>();
      String? userString = SharedPrefs().user;
      String? token = SharedPrefs().token;

      if (userString.isNotEmpty && token.isNotEmpty) {
        User user = User.fromJson(jsonDecode(userString));
        await userProvider.setUser(user, token);
        /* Future.delayed(const Duration(seconds: 4), () {
          if (mounted) {
            setState(() {
              _isNotConnect = false;
            });
          }
        }); 
        ScaffoldMessenger.of(context).showSnackBar(MySnackBars.simpleSnackbar(
            "Ya ha iniciado sesión", Icons.key_outlined, Styles.green)); */
        Navigator.of(context).pushReplacementNamed(HomeView.id);
      } else {
        onStateConnect(false);
        return;
      }
    } catch (e) {
      onStateConnect(false);
      return;
    }
  }

  Future<void> saveCredentials(user, String token) async {
    var userString = jsonDecode(jsonEncode(userToJson(user)));
    SharedPrefs().user = userString;
    SharedPrefs().token = token;
  }
}
