import 'package:flutter/material.dart';
import 'package:vivo_vivo_app/src/screens/Home/home_view.dart';
import 'package:vivo_vivo_app/src/screens/Login/login_view.dart';
import 'package:vivo_vivo_app/src/screens/Register/step_one_register_view.dart';
import 'package:vivo_vivo_app/src/screens/Register/step_two_register_view.dart';
import 'package:vivo_vivo_app/src/screens/RemeberPassword/remember_password.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Map<String, dynamic Function(BuildContext)> routes = {
      LoginView.id: (_) => const LoginView(),
      HomeView.id: (_) => const HomeView(),
      StepOneRegisterView.id: (_) => const StepOneRegisterView(),
      StepTwoRegisterView.id: (_) => const StepTwoRegisterView(),
      RememberPassView.id: (_) => const RememberPassView()
    };

    final routeBuilder = routes[settings.name];
    if (routeBuilder != null) {
      return MaterialPageRoute(
        builder: (context) => routeBuilder(context),
        settings: settings,
      );
    }

    return MaterialPageRoute(builder: (context) => const LoginView());
  }
}
