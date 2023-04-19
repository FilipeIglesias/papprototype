import 'package:flutter/material.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(
            top: 50,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 0, left: 10),
                child: Container(
                  child: Text(
                    "About",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 35,
                        fontFamily: 'SFProDisplay',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
