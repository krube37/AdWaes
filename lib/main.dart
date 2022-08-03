import 'package:ad/provider/news_paper_provider.dart';
import 'package:ad/screens/adwaes_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase/auth_manager.dart';
import 'firebase/local_user.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AuthManager authManager = AuthManager();
  // ProductDataProvider newsPaperProvider = ProductDataProvider();
  // todo : initialise variables in newspaper provider

  runApp(
    MultiProvider(
      providers: [
        StreamProvider<LocalUser?>(create: (context) => authManager.onAuthStateChange, initialData: null),
        ChangeNotifierProvider<ProductDataProvider>(create: (_) => ProductDataProvider()),
        ChangeNotifierProvider<ProductEventProvider>(create: (_) => ProductEventProvider()),
      ],
      child: Consumer<LocalUser?>(
        builder: (_, user, __) {
          print("_AdWaesAppState build: user $user");
          AuthManager authManager = AuthManager();
          authManager.user = user;
          return const AdWaesApp();
        },
      ),
    ),
  );
}
