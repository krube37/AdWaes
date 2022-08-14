part of sign_in;



class SignInManager {
  Future<AdWiseUser?> showSignInDialog(BuildContext context) async {
    return await showDialog<AdWiseUser?>(
        context: context,
        builder: (context) {
          return ChangeNotifierProvider(
            create: (_) => SignInProvider(),
            builder: (context, child) =>
                const SignInCard(),
          );
        });
  }
}


class _CustomTextField extends StatelessWidget {
  final String hintText;
  final String? labelText, errorText;
  final TextEditingController? controller;
  final Function(String)? onFieldSubmitted;


  const _CustomTextField(
      this.hintText, {
        Key? key,
        this.labelText,
        this.controller,
        this.errorText,
        this.onFieldSubmitted,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
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
      ),
    );
  }
}

class _CustomButton extends StatefulWidget {
  final String buttonText;
  final Function? onPressed;
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
              widget.onPressed?.call();
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

