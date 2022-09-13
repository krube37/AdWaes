import 'package:ad/provider/data_manager.dart';
import 'package:ad/screens/adwaes_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print(" main: current user ${FirebaseAuth.instance.currentUser?.uid}");
  DataManager dataManager = DataManager();
  await dataManager.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => dataManager),
      ],
      child: Consumer<DataManager>(
        builder: (_, dataManagerValue, __) {
          print("_AdWaesAppState build: user ${dataManagerValue.user}");
          return const AdWaesApp();
        },
      ),
    ),
  );
}
