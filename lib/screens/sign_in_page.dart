library manage_sign_in;

import 'package:ad/globals.dart';
import 'package:ad/provider/sign_in_provider.dart';
import 'package:ad/widgets/sign_in_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

part 'sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late TextEditingController _emailTextController, _passwordTextController;
  late SignInProvider _signInProvider;

  @override
  void initState() {
    super.initState();

    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    _signInProvider = SignInProvider();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    DeviceScreenType screenType = getDeviceType(screenSize);
    bool isDesktopView = screenType == DeviceScreenType.desktop;

    return ChangeNotifierProvider(
      create: (BuildContext context) => _signInProvider,
      builder: (context, _) {
        return Scaffold(
          appBar: getAppBar(MediaQuery.of(context).size),
          body: Row(
            children: [
              isDesktopView ? const Expanded(flex: 10, child: Placeholder()) : const SizedBox(),
              Expanded(
                flex: 7,
                child: SingleChildScrollView(
                  child: SignInCard(
                    emailTextController: _emailTextController,
                    passwordTextController: _passwordTextController,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
  }
}
