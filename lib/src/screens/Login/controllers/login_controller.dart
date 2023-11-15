import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivo_vivo_app/src/commons/create_credentials.dart';

import 'package:vivo_vivo_app/src/commons/shared_preferences.dart';
import 'package:vivo_vivo_app/src/data/datasource/mongo/api_repository_user_impl.dart';
import 'package:vivo_vivo_app/src/domain/models/user_pref_provider.dart';
// import 'package:vivo_vivo_app/src/global/global_variable.dart';
import 'package:vivo_vivo_app/src/providers/user_provider.dart';
import 'package:vivo_vivo_app/src/screens/Home/home_view.dart';
// import 'package:vivo_vivo_app/src/utils/snackbars.dart';

class LoginController {
  late final Function(bool state) onStateConnect;
  late ApiRepositoryUserImpl userService;
  late UserProvider userProvider;
  late BuildContext context;

  LoginController(BuildContext newContext) {
    context = newContext;
    userService = ApiRepositoryUserImpl();
    userProvider = context.read<UserProvider>();
  }

  Future<void> showHomePage( String userName,
      String password) async {
    var res = await userService.getUser(createCredentials(userName, password));
    if (res == null || res.error) return onStateConnect(false);
    final UserPrefProvider user = UserPrefProvider.fromJson(res.data);
    userProvider.getUser(user.getUser, user.getToken);
    saveCredentials(user.getUser, user.getToken);
    Navigator.of(context).pushReplacementNamed(HomeView.id);
  }
  
  Future<void> saveCredentials(UserAuth user, String token) async {
    var userString = userAuthToJson(user);
    SharedPrefs().user = userString;
    SharedPrefs().token = token;
  }
}
