part of sign_in;

class NewUserFieldsCard extends StatefulWidget {
  final AdWiseUser user;

  const NewUserFieldsCard({Key? key, required this.user}) : super(key: key);

  @override
  State<NewUserFieldsCard> createState() => _NewUserFieldsCardState();
}

class _NewUserFieldsCardState extends State<NewUserFieldsCard> {
  late UpdateUserDetailsProvider _provider;
  late ScrollController _scrollController;

  String? userNameErrorText, firstNameErrorText, phoneNumberErrorText, companyErrorText, emailErrorText;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    _provider = Provider.of<UpdateUserDetailsProvider>(context);
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        debugPrint("_NewUserFieldsCardState build: requesting for pop");
        return true;
      },
      child: Center(
        child: Container(
          width: 500,
          height: screenSize.height - 100,
          constraints: const BoxConstraints(
            minHeight: 700,
          ),
          margin: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Column(
                children: [
                  const Text(
                    'Setup Profile',
                    style: TextStyle(fontSize: 30.0),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10.0,
                            ),
                            _CustomSignInTextField(
                              'user name',
                              outerLabelText: 'user name',
                              controller: _provider.userNameTextController,
                              errorText: userNameErrorText,
                              isRequiredField: true,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: _CustomSignInTextField(
                                  'First name',
                                  outerLabelText: 'First Name',
                                  controller: _provider.firstNameTextController,
                                  errorText: firstNameErrorText,
                                )),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                    child: _CustomSignInTextField(
                                  'Last name',
                                  outerLabelText: 'Last Name',
                                  controller: _provider.lastNameTextController,
                                )),
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            _CustomSignInTextField(
                              'phone number',
                              outerLabelText: 'phone number',
                              controller: _provider.phoneNumberTextController,
                              keyboardType: TextInputType.phone,
                              isRequiredField: true,
                              cursor: SystemMouseCursors.forbidden,
                              enabled: false,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            _VerifyEmailTextView(
                              isVerified: widget.user.isEmailVerified,
                              errorText: emailErrorText,
                              hasEmail: widget.user.emailId != null,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            StatefulBuilder(builder: (context, setState) {
                              DateTime? pickedAge;
                              pickAge() async {
                                pickedAge = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime(1990),
                                    firstDate: DateTime(1800),
                                    lastDate: DateTime.now());
                                setState(() {
                                  _provider.ageTextController.text =
                                      pickedAge != null ? DateFormat('dd/MM/yyyy').format(pickedAge!) : '';
                                });
                              }

                              return Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: _CustomSignInTextField(
                                      'Date of birth',
                                      outerLabelText: 'Date of birth',
                                      controller: _provider.ageTextController,
                                      keyboardType: TextInputType.number,
                                      cursor: SystemMouseCursors.forbidden,
                                      enabled: false,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  if (_provider.ageTextController.text.trim().isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(25.0),
                                        onTap: () => setState(() => _provider.ageTextController.text = ''),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.clear_rounded,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0, left: 10.0),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(25.0),
                                      onTap: pickAge,
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Icons.date_range),
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                    flex: 1,
                                    child: SizedBox(),
                                  )
                                ],
                              );
                            }),
                            const SizedBox(
                              height: 10.0,
                            ),
                            _CustomSignInTextField(
                              'company name',
                              outerLabelText: 'company name',
                              controller: _provider.companyTextController,
                              errorText: companyErrorText,
                              isRequiredField: true,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: _CustomSignInTextField(
                                    'gst number',
                                    outerLabelText: 'gst number',
                                    controller: _provider.gstTextController,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: _CustomSignInTextField(
                                    'business type',
                                    outerLabelText: 'business type',
                                    controller: _provider.businessTypeTextController,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            _UpdateUserDetailsButton(onPressed: _updateUserDetails)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _validateFilledFields() {
    userNameErrorText = firstNameErrorText = phoneNumberErrorText = companyErrorText = null;
    bool isValid = true;

    if (_provider.userNameTextController.text.trim().isEmpty) {
      isValid = false;
      userNameErrorText = "UserName is empty";
    }
    if (_provider.phoneNumberTextController.text.trim().isEmpty) {
      isValid = false;
      phoneNumberErrorText = "Phone number is empty";
    }
    if (_provider.companyTextController.text.trim().isEmpty) {
      isValid = false;
      companyErrorText = "Company name is empty";
    }
    return isValid;
  }

  _updateUserDetails() async {
    if (!_validateFilledFields()) {
      setState(() {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 700),
          curve: Curves.fastOutSlowIn,
        );
      });
      return;
    }
    _provider.setSavingDetailsState();
    String emailId = _provider.emailIdTextController.text.trim();
    debugPrint(
        "_NewUserFieldsCardState _updateUserDetails: ${widget.user.isEmailVerified} email ${widget.user.emailId}");
    if (emailId.isNotEmpty && widget.user.emailId == null) {
      ApiResponse response = await AuthManager().addEmailAddress(emailId);
      if (!response.status) {
        setState(() {
          if (response.errorMessage!.contains('firebase_auth/email-already-in-use')) {
            emailErrorText = 'this email is linked with another account';
          }
          _provider.setIdleState();
        });
        return;
      }
    }

    String age = _provider.ageTextController.text.trim();

    AdWiseUser updatedUser = widget.user.copyWith(
      userName: _provider.userNameTextController.text.trim(),
      firstName: _provider.firstNameTextController.text.trim(),
      lastName: _provider.lastNameTextController.text.trim(),
      emailId: emailId,
      companyName: _provider.companyTextController.text.trim(),
      gstNumber: _provider.gstTextController.text.trim(),
      age: age.isNotEmpty ? int.parse(age) : null,
      businessType: _provider.businessTypeTextController.text.trim(),
    );

    bool isUpdated = await FirestoreDatabase().updateUserDetails(updatedUser);
    if (isUpdated) {
      if (mounted) Navigator.pop(context, updatedUser);
    } else {
      _provider.setIdleState(userDetailsErrorMessage: 'something went wrong!');
    }
  }
}

class _UpdateUserDetailsButton extends StatefulWidget {
  final Function onPressed;
  final String buttonText = 'Save';

  const _UpdateUserDetailsButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  State<_UpdateUserDetailsButton> createState() => _UpdateUserDetailsButtonState();
}

class _UpdateUserDetailsButtonState extends State<_UpdateUserDetailsButton> {
  late UpdateUserDetailsProvider _provider;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    _provider = Provider.of<UpdateUserDetailsProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IgnorePointer(
          ignoring: _provider.isSavingUserDetails,
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
                  child: _provider.isSavingUserDetails
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
        _provider.userDetailsErrorMessage != null
            ? Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _provider.userDetailsErrorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              )
            : const SizedBox()
      ],
    );
  }
}

class _VerifyEmailTextView extends StatefulWidget {
  final bool enabled, hasEmail;
  final bool? isVerified;
  final String? errorText;
  final MouseCursor? cursor;

  const _VerifyEmailTextView({this.isVerified, this.errorText, this.hasEmail = false})
      : enabled = true,
        cursor = null;

  @override
  State<_VerifyEmailTextView> createState() => _VerifyEmailTextViewState();
}

class _VerifyEmailTextViewState extends State<_VerifyEmailTextView> {
  late UpdateUserDetailsProvider _provider;
  bool isVerifying = false;
  String? errorText;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _provider = Provider.of<UpdateUserDetailsProvider>(context);
    errorText = widget.errorText;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _CustomSignInTextField(
            'email id',
            outerLabelText: 'email id',
            controller: _provider.emailIdTextController,
            keyboardType: TextInputType.emailAddress,
            errorText: errorText,
            cursor: widget.cursor,
            enabled: widget.enabled,
          ),
        ),
        if (widget.hasEmail)
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 10.0),
            child: !isVerifying
                ? IgnorePointer(
                    ignoring: widget.isVerified!,
                    child: InkWell(
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: _verifyEmail,
                      child: Text(
                        widget.isVerified! ? 'verified' : 'verify',
                        style: TextStyle(color: widget.isVerified! ? Colors.green : Colors.red),
                      ),
                    ),
                  )
                : const SizedBox(
                    height: 15.0,
                    width: 15.0,
                    child: CircularProgressIndicator(
                      color: Colors.grey,
                      strokeWidth: 2.0,
                    ),
                  ),
          ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }

  _verifyEmail() {
    if (_provider.emailIdTextController.text.trim().isEmpty) {
      setState(() => errorText = 'email address is empty');
      return;
    }
    setState(() {
      isVerifying = true;
    });
    //todo: verify email
  }
}
