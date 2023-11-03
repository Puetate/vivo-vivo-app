import 'package:flutter/material.dart';
import 'package:vivo_vivo_app/src/screens/Home/home_view.dart';
import 'package:vivo_vivo_app/src/screens/Login/login_view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Map<String, dynamic Function(BuildContext)> routes = {
      LoginView.id: (_) => const LoginView(),
      HomeView.id: (_) => const HomeView(),
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
