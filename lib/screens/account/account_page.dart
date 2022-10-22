import 'package:ad/adwise_user.dart';
import 'package:ad/globals.dart';
import 'package:ad/screens/account/personal_info_page.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  final AdWiseUser user;

  const AccountPage({Key? key, required this.user}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Flutter',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.grey.shade50,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 1100.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 70.0),
                    const Text(
                      "Container",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30.0,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      "changes of container reflect here",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    !isMobileView(context)
                        ? GridView.builder(
                            shrinkWrap: true,
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 500,
                              mainAxisExtent: 200,
                            ),
                            itemBuilder: (context, index) => _AccountDesktopTile(
                              user: widget.user,
                            ),
                            itemCount: 9,
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: 9,
                            itemBuilder: (context, index) => _AccountMobileTile(
                              user: widget.user,
                            ),
                          ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 500.0),
          ],
        ),
      ),
    );
  }
}

class _AccountDesktopTile extends StatelessWidget {
  final AdWiseUser user;

  const _AccountDesktopTile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return PersonalInfoPage(
              user: user,
            );
          }));
        },
        child: Card(
          elevation: 2.0,
          shadowColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: const [
                Icon(
                  Icons.account_circle_rounded,
                  color: Colors.grey,
                  size: 50.0,
                ),
                SizedBox(height: 20.0),
                Text(
                  'Card headline',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 15.0),
                Text(
                  'this is the card information',
                  style: TextStyle(fontSize: 13.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AccountMobileTile extends StatelessWidget {
  final AdWiseUser user;

  const _AccountMobileTile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return PersonalInfoPage(
              user: user,
            );
          }));
        },
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade100),
            ),
          ),
          child: Row(
            children: const [
              Icon(
                Icons.account_circle_rounded,
                color: Colors.grey,
              ),
              SizedBox(width: 15.0),
              Expanded(
                child: Text(
                  'Card headline',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.grey,
                size: 14.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
