import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vivo_vivo_app/src/domain/api/vivo_vivo_api.dart';
import 'package:vivo_vivo_app/src/global/global_variable.dart';
import 'package:vivo_vivo_app/src/providers/socket_provider.dart';
import 'package:vivo_vivo_app/src/routes/route_generator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

Future main() async {
  await dotenv.load();
  Api.configureDio();
  runApp(MultiProvider(
    providers: [
      // ChangeNotifierProvider(create: (_) => User()),
      Provider(create: (_) => SocketProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      navigatorKey: GlobalVariable.navigatorState,
      supportedLocales: const [Locale("es", "ES"), Locale("en", "EN")],
      initialRoute: "/",
      debugShowCheckedModeBanner: false,
      title: 'Vivo Vivo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyanAccent),
          useMaterial3: true),
      onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings),
    );
  }
}
