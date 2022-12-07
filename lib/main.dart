import 'package:ad/provider/data_manager.dart';
import 'package:ad/routes/my_route_delegate.dart';
import 'package:ad/routes/route_parser.dart';
import 'package:ad/utils/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'firebase_options.dart';
import 'general_settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint(" main: current user ${FirebaseAuth.instance.currentUser?.uid}");
  DataManager dataManager = DataManager();
  GeneralSettingsProvider settings = GeneralSettingsProvider();
  await dataManager.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => dataManager),
        ChangeNotifierProvider(create: (_) => settings),
      ],
      child: Consumer<DataManager>(
        builder: (_, dataManagerValue, __) {
          return Consumer<GeneralSettingsProvider>(
            builder: (_, settingsProvider, __) {
              debugPrint("_AdWaesAppState build: user ${dataManagerValue.user}");
              return MaterialApp.router(
                title: 'Adwisor',
                theme: defaultTheme,
                darkTheme: darkTheme,
                themeMode: GeneralSettingsProvider().themeMode,
                debugShowCheckedModeBanner: false,
                routerDelegate: MyRouteDelegate(),
                routeInformationParser: RouteParser(),
                builder: (context, child) => Overlay(
                  initialEntries: [
                    OverlayEntry(builder: (context)=> child!)
                  ],
                ),
              );
            },
          );
        },
      ),
    ),
  );
}
