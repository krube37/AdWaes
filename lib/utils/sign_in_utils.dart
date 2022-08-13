import 'package:ad/provider/sign_in_provider.dart';
import 'package:ad/widgets/sign_in_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../globals.dart';

class SignInUtils {
  showSignInDialog(BuildContext context, TextEditingController emailTextController,
      TextEditingController passwordTextController) async {
    await showDialog(
        context: context,
        builder: (context) {
          return ChangeNotifierProvider(
            create: (_) => SignInProvider(),
            builder: (context, child) =>
                SignInCard(mobileNumberTextController: emailTextController, passwordTextController: passwordTextController),
          );
        });
  }
}

