import 'package:ad/media/firebase/auth_manager.dart';
import 'package:ad/media/firebase/local_user.dart';
import 'package:ad/screens/adwaes_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AuthManager authManager = AuthManager();

  runApp(
    StreamProvider<LocalUser?>(
        create: (BuildContext context) => authManager.onAuthStateChange,
        initialData: null,
        child: Consumer<LocalUser?>(
          builder: (_, user, __) {
            print("_AdWaesAppState build: checkzzz user $user");
            AuthManager authManager = AuthManager();
            authManager.user = user;
            return const AdWaesApp();
          },
        )
        ),
  );
}
