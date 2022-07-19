library pre_process_sign_in;

import 'package:ad/constants.dart';
import 'package:ad/globals.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../media/firebase/auth_manager.dart';
import '../provider/sign_in_provider.dart';
import '../routes/routes.dart';

part 'sign_up_card.dart';

class SignInCard extends StatefulWidget {
  final TextEditingController emailTextController, passwordTextController;

  const SignInCard({
    Key? key,
    required this.emailTextController,
    required this.passwordTextController,
  }) : super(key: key);

  @override
  State<SignInCard> createState() => _SignInCardState();
}

class _SignInCardState extends State<SignInCard> {
  String? _emailErrorText, _passwordErrorText;
  late SignInProvider _provider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _provider = Provider.of<SignInProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        margin: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
            child: Column(
              children: [
                _CustomTextField(
                  'Your Email Address',
                  labelText: 'Email Address',
                  controller: widget.emailTextController,
                  errorText: _emailErrorText,
                ),
                _CustomTextField(
                  'Your Password',
                  labelText: 'Password',
                  controller: widget.passwordTextController,
                  errorText: _passwordErrorText,
                ),
                const SizedBox(
                  height: 20,
                ),
                _CustomButton(
                  'Sign In',
                  onPressed: _onSignInButtonClicked,
                ),
                const SizedBox(
                  height: 10,
                ),
                _CustomButton(
                  'Sign in with Google',
                  iconName: 'images/google_icon.png',
                  onPressed: _onGoogleSignInClicked,
                  isGoogleBtn: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                    child: RichText(
                  text: TextSpan(children: [
                    const TextSpan(
                      text: "Don't have an Account? ",
                    ),
                    TextSpan(
                      text: 'Sign up',
                      style: const TextStyle(
                        color: Colors.blue,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacementNamed(context, Routes.SIGN_UP);
                        },
                    )
                  ]),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _validateFilledFields(String email, String password) {
    bool isValid = true;
    _emailErrorText = _passwordErrorText = null;

    if (email.isEmpty) {
      _emailErrorText = 'Email is Empty';
      isValid = false;
    } else if (_isInValidEmail(email)) {
      _emailErrorText = 'Enter a valid email';
      isValid = false;
    }
    if (password.isEmpty) {
      _passwordErrorText = 'Password is Empty';
      isValid = false;
    }
    return isValid;
  }

  _onSignInButtonClicked() async {
    String email = widget.emailTextController.text.trim();
    String password = widget.passwordTextController.text.trim();
    bool isValid = _validateFilledFields(email, password);

    if (!isValid) {
      setState(() {});
      return;
    }

    _provider.setLoadingState();

    // for now using boolean, later need to mention all firebase errors in UI
    bool isSuccess =
        await AuthManager().signIn(widget.emailTextController.text.trim(), widget.passwordTextController.text.trim());
    await Future.delayed(const Duration(seconds: 4));
    if (isSuccess) {
      // User Signed In... navigate to home page
      if (!mounted) return;
      // Navigator.pushReplacementNamed(context, Routes.HOME_ROUTE);
      print("_DesktopPageState build: success ");
    } else {
      _provider.setIdleState(errorMessage: 'Invalid credentials');
      print("_DesktopPageState build: failed ");
    }
  }

  _onGoogleSignInClicked() async {
    print("_SignInCardState _onGoogleSignInClicked: checkzzzz into on pressed ");
    _provider.setGoogleLoadingState();
    bool isSuccess = await AuthManager().signInWithGoogle();
    _provider.setIdleState(googleErrorMessage: isSuccess ? null : 'Something went wrong!');
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home');
  }
}

bool _isInValidEmail(String email) => (!email.contains('@') ||
    email.startsWith('@') ||
    email.endsWith('@') ||
    email.startsWith('.') ||
    email.endsWith('.') ||
    !email.contains('.') ||
    email.contains('@.'));

class _CustomTextField extends StatelessWidget {
  final String hintText;
  final String? labelText, errorText;
  final TextEditingController? controller;

  const _CustomTextField(this.hintText, {Key? key, this.labelText, this.controller, this.errorText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.0),
              borderSide: const BorderSide(
                width: 0.5,
              )),
          errorText: errorText,
        ),
      ),
    );
  }
}

class _CustomButton extends StatefulWidget {
  final String buttonText;
  final Function? onPressed;
  final String? iconName;
  final bool isGoogleBtn;

  const _CustomButton(this.buttonText, {Key? key, this.onPressed, this.iconName, this.isGoogleBtn = false})
      : super(key: key);

  @override
  State<_CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<_CustomButton> {
  late SignInProvider provider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    provider = Provider.of<SignInProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    String? errorMessage = widget.isGoogleBtn ? provider.googleErrorMessage : provider.errorMessage;
    return Column(
      children: [
        IgnorePointer(
          ignoring: provider.isLoading || provider.isGoogleLoading,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
              ),
              onPressed: () {
                widget.onPressed?.call();
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: (widget.isGoogleBtn ? provider.isGoogleLoading : provider.isLoading)
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ))
                      : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          widget.iconName != null
                              ? Image.asset(
                                  widget.iconName!,
                                  scale: 4,
                                )
                              : const SizedBox(),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(widget.buttonText)
                        ]),
                ),
              )),
        ),
        const SizedBox(
          height: 5,
        ),
        errorMessage != null
            ? Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              )
            : const SizedBox()
      ],
    );
  }
}
