import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Login_Page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF8B5A2B), // Dark brown
                  Color(0xFFC19A6B), // Light brown
                  Color(0xFF8B5A2B), // Dark brown
                ],
              ),
            ),
            child: Image.asset(
              "assets/images/bg10.png",
              fit: BoxFit.cover,
              // width: double.infinity,
              height: double.infinity,
            )));
  }
}
