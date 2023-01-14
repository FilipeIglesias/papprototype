import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                      style: TextStyle(fontSize: 40),
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
            ],
          ),
        ),
      ),
    );
  }
}
