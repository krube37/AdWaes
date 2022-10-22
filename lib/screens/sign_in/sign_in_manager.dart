part of sign_in;

class SignInManager {
  Future<AdWiseUser?> showSignInDialog(BuildContext context, {Function(SnackBar snackBar)? showToast}) async {
    AdWiseUser? user = await showDialog<AdWiseUser?>(
        context: context,
        builder: (context) {
          return ChangeNotifierProvider(
            create: (_) => SignInProvider(),
            builder: (context, child) => const SignInCard(),
          );
        });

    if (user == null) {
      SnackBar snackBar = const SnackBar(
        content: Text('Login Failed!'),
        behavior: SnackBarBehavior.floating,
        width: 500.0,
      );
      showToast?.call(snackBar);
      return null;
    }
    await DataManager().initialiseUserCreds(user);
    SnackBar snackBar = const SnackBar(
      content: Text('Successfully logged in'),
      behavior: SnackBarBehavior.floating,
      width: 500.0,
    );
    showToast?.call(snackBar);
    return user;
  }

  Future<AdWiseUser> showNewUserFields(BuildContext context, AdWiseUser user) async {
    AdWiseUser? updatedUser = await showDialog<AdWiseUser>(
        context: context,
        builder: (context) {
          return ChangeNotifierProvider(
            create: (_) => UpdateUserDetailsProvider(user),
            builder: (context, child) => NewUserFieldsCard(user: user),
          );
        });

    return updatedUser ?? user;
  }
}

class _CustomSignInTextField extends StatelessWidget {
  final String hintText;
  final String? labelText, outerLabelText, errorText;
  final TextEditingController? controller;
  final Function(String)? onFieldSubmitted;
  final bool isRequiredField;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final GestureTapCallback? onTap;
  final MouseCursor? cursor;
  final bool enabled;

  const _CustomSignInTextField(
    this.hintText, {
    Key? key,
    this.labelText,
    this.outerLabelText,
    this.controller,
    this.focusNode,
    this.errorText,
    this.onFieldSubmitted,
    this.keyboardType,
    this.onTap,
    this.cursor,
    this.enabled = true,
    this.isRequiredField = false,
  })  : assert((outerLabelText == null || labelText == null),
            'labelText and outerLabelText are for same purpose. Should not provide both'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (outerLabelText != null)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: RichText(
                    text: TextSpan(text: outerLabelText!, children: [
                  if (isRequiredField) const TextSpan(text: '*', style: TextStyle(color: Colors.red)),
                ])),
              ),
            if (outerLabelText != null)
              const SizedBox(
                height: 10,
              ),
            TextFormField(
              focusNode: focusNode ?? FocusNode(),
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
              onFieldSubmitted: onFieldSubmitted,
              keyboardType: keyboardType,
              onTap: onTap,
              mouseCursor: cursor,
              enabled: enabled,
            ),
          ],
        ));
  }
}

class _CustomButton extends StatefulWidget {
  final String buttonText;
  final Function onPressed;
  final bool isSignInBtn;

  const _CustomButton.signInButton({required this.onPressed})
      : buttonText = 'Sign In',
        isSignInBtn = true;

  const _CustomButton.continueBtn({required this.onPressed})
      : buttonText = 'Continue',
        isSignInBtn = false;

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
    String? errorMessage = widget.isSignInBtn ? provider.otpErrorMessage : provider.phoneNumberErrorMessage;
    return Column(
      children: [
        IgnorePointer(
          ignoring: provider.isSendingOtp,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
            ),
            onPressed: () {
              widget.onPressed.call();
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                  child: (widget.isSignInBtn ? provider.isVerifyingOtp : provider.isSendingOtp)
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ))
                      : Text(widget.buttonText)),
            ),
          ),
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
