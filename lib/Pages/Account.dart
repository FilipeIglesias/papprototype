import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:papprototype/about.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mailto/mailto.dart';
import 'package:papprototype/ui/view_models/app_view_model.dart';
import '../account_settings.dart';
import '../ui/help.dart';
import 'login_page.dart';

class Account extends StatefulWidget {
  final FirebaseAuth auth;
  const Account({super.key, required this.auth});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(
            top: 50,
          ),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 0, left: 10),
                      child: Text(
                        'Settings',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 35,
                            fontFamily: 'SFProDisplay',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0, left: 160),
                      child: CircleAvatar(
                        backgroundColor: Colors.orangeAccent,
                        radius: 35,
                        backgroundImage: AssetImage('images/pfp.png'),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 60, left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ChangeEmailOrPasswordPage(auth: FirebaseAuth.instance,)));
                      },
                      child: Text('Account',style: TextStyle(fontSize: 30),),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 7, left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Help()));
                      },
                      child: Text(
                        'Help', style: TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 7, left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {Navigator.push(context,
                            MaterialPageRoute(builder: (context) => About()));},
                      child: Text('About',style: TextStyle(fontSize: 30),),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 7, left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      child: Text('Logout', style: TextStyle(fontSize: 30),),
                      onTap: () async {
                        await auth.signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => LoginPage()),
                          (route) => false,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
