import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:vivo_vivo_app/src/commons/shared_preferences.dart';
import 'package:vivo_vivo_app/src/domain/api/dio.config.dart';
import 'package:vivo_vivo_app/src/global/global_variable.dart';
import 'package:vivo_vivo_app/src/providers/alarm_state_provider.dart';
import 'package:vivo_vivo_app/src/providers/geolocation_provider.dart';
import 'package:vivo_vivo_app/src/providers/socket_provider.dart';
import 'package:vivo_vivo_app/src/providers/user_provider.dart';
import 'package:vivo_vivo_app/src/routes/route_generator.dart';
import 'package:vivo_vivo_app/src/screens/Home/home_view.dart';
import 'package:vivo_vivo_app/src/screens/Login/login_view.dart';
import 'package:vivo_vivo_app/src/utils/app_styles.dart';

Future main() async {
  await dotenv.load();
  DioSingleton.getInstance();
  await SharedPrefs().init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => AlarmStateProvider()),
      ChangeNotifierProvider(create: (_) => GeoLocationProvider()),
      ChangeNotifierProvider(create: (_) => SocketProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      navigatorKey: GlobalVariable.navigatorState,
      supportedLocales: const [Locale("es", "ES"), Locale("en", "EN")],
      initialRoute:
          (SharedPrefs().user.isNotEmpty) ? HomeView.id : LoginView.id,
      debugShowCheckedModeBanner: false,
      title: 'Vivo Vivo',
      theme: ThemeData(
          colorScheme: theme.colorScheme.copyWith(primary: Styles.primaryColor),
          useMaterial3: false),
      onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings),
    );
  }
}
