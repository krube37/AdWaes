part of manage_sign_in;

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController _firstNameTextController,
      _lastNameTextController,
      _emailTextController,
      _passwordTextController,
      _confirmPassTextController;
  late SignInProvider _signInProvider;

  @override
  void initState() {
    super.initState();

    _firstNameTextController = TextEditingController();
    _lastNameTextController = TextEditingController();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    _confirmPassTextController = TextEditingController();
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
          _signInProvider = Provider.of<SignInProvider>(context);

          return Scaffold(
            appBar: isDesktopView
                ? PreferredSize(
                    preferredSize: Size(screenSize.width, 100),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      color: const Color.fromARGB(255, 0, 0, 0),
                      child: const Text(
                        'Adwisor',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 48,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.bold,
                          //letterSpacing: 3,
                        ),
                      ),
                    ),
                  )
                : AppBar(
                    iconTheme: const IconThemeData(color: Colors.white),
                    elevation: 0,
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(1),
                    title: const Text(
                      'Adwisor',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 24,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold,
                        //letterSpacing: 3,
                      ),
                    ),
                  ),
            body: Row(
              children: [
                isDesktopView ? const Expanded(flex: 10, child: Placeholder()) : const SizedBox(),
                Expanded(
                  flex: 7,
                  child: SingleChildScrollView(
                    child: SignUpCard(
                      firstNameTextController: _firstNameTextController,
                      lastNameTextController: _lastNameTextController,
                      emailTextController: _emailTextController,
                      passwordTextController: _passwordTextController,
                      confirmPassTextController: _confirmPassTextController,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  void dispose() {
    _firstNameTextController.dispose();
    _lastNameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _confirmPassTextController.dispose();
    super.dispose();
  }
}
