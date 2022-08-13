part of sign_in;

class SignUpCard extends StatefulWidget {
  final TextEditingController firstNameTextController,
      lastNameTextController,
      emailTextController,
      passwordTextController,
      confirmPassTextController;

  const SignUpCard(
      {Key? key,
      required this.firstNameTextController,
      required this.lastNameTextController,
      required this.emailTextController,
      required this.passwordTextController,
      required this.confirmPassTextController,})
      : super(key: key);

  @override
  State<SignUpCard> createState() => _SignUpCardState();
}

class _SignUpCardState extends State<SignUpCard> {
  String? _firstNameErrorText, _emailErrorText, _passwordErrorText, _confirmPassErrorText;
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
                  'Your First Name',
                  labelText: 'First Name',
                  controller: widget.firstNameTextController,
                  errorText: _firstNameErrorText,
                ),
                _CustomTextField('Your Last Name',
                    labelText: 'Last Name (optional)', controller: widget.lastNameTextController),
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
                _CustomTextField(
                  'Confirm Your Password',
                  labelText: 'Confirm Password',
                  controller: widget.confirmPassTextController,
                  errorText: _confirmPassErrorText,
                ),
                const SizedBox(
                  height: 20,
                ),
                // _CustomButton(
                //   'Sign Up',
                //   onPressed: () async {
                //     String firstName = widget.firstNameTextController.text.trim();
                //     String lastName = widget.lastNameTextController.text.trim();
                //     String email = widget.emailTextController.text.trim();
                //     String password = widget.passwordTextController.text.trim();
                //     String confirmPass = widget.confirmPassTextController.text.trim();
                //
                //     bool isValid = _validateFilledFields(firstName, email, password, confirmPass);
                //
                //
                //     if (!isValid) {
                //       setState(() {});
                //       return;
                //     }
                //     _provider.setSendingOtpState();
                //
                //     // bool isSuccess = await AuthManager().createUser(
                //     //     widget.emailTextController.text.trim(), widget.passwordTextController.text.trim()) == FirebaseResult.success;
                //     // await Future.delayed(const Duration(seconds: 4));
                //     //
                //     // _provider.setIdleState(errorMessage: isSuccess ? null : "Something went wrong");
                //     //
                //     // if (isSuccess) {
                //     //   print("_DesktopPageState build: success ");
                //     // } else {
                //     //   print("_DesktopPageState build: failed ");
                //     // }
                //   },
                // ),
                const SizedBox(
                  height: 10,
                ),
                // Center(
                //     child: RichText(
                //   text: TextSpan(children: [
                //     const TextSpan(
                //       text: "Already have an account? ",
                //     ),
                //     TextSpan(
                //       text: 'Sign in',
                //       style: const TextStyle(
                //         color: Colors.blue,
                //       ),
                //       recognizer: TapGestureRecognizer()
                //         ..onTap = () {
                //           Navigator.pushReplacementNamed(context, Routes.SIGN_IN);
                //         },
                //     )
                //   ]),
                // ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _validateFilledFields(String firstName, String email, String password, String confirmPass) {
    bool isValid = true;
    _firstNameErrorText = _emailErrorText = _passwordErrorText = _confirmPassErrorText = null;

    if (firstName.isEmpty) {
      _firstNameErrorText = 'Name should not be Empty';
      isValid = false;
    }

    if (email.isEmpty) {
      _emailErrorText = 'Email should not be empty';
      isValid = false;
    } else if (_isInValidEmail(email)) {
      _emailErrorText = 'Enter a valid Email';
      isValid = false;
    }

    if (password.isEmpty) {
      _passwordErrorText = 'Password is empty';
      isValid = false;
    } else {
      if (confirmPass.isEmpty) {
        _confirmPassErrorText = 'Password is empty';
        isValid = false;
      } else if (password != confirmPass) {
        _confirmPassErrorText = "Password doesn't match";
        isValid = false;
      }
    }
    return isValid;
  }
}
