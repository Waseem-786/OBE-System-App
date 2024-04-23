import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Login_Page.dart';

import 'Dashboard.dart';
import 'Token.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 1), () {
      _handleTokenVerification();
    });
  }

  Future<void> _handleTokenVerification() async {
    await handleTokenVerification(); // Call your asynchronous logic here
  }
  /*
    It attempts to read the access token.
    If the access token exists, it verifies its validity.
    If the access token is valid, it navigates to the Dashboard.
    If the access token is not valid, it attempts to read the refresh token.
    If the refresh token exists, it verifies its validity.
    If the refresh token is valid, it attempts to refresh the access token.
    If the access token is successfully refreshed, it verifies its validity again.
    If the access token is now valid, it navigates to the Dashboard.
  */
  Future<void> handleTokenVerification() async {
    //Read AccessToken & Check validity and route to Dashboard
    String? accessToken = await Token.readAccessToken();
    if (accessToken != null) {
      bool verified = await Token.verifyToken(accessToken!);
      if (verified) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashboard_Page())
        );
      }
      //If not verified then updated access token by reading refresh token and verifying refresh token
      else {
        String? refreshToken = await Token.readRefreshToken();
        if (refreshToken != null) {
          bool verified = await Token.verifyToken(refreshToken!);
          if (verified) {
            bool refresh = await Token.refreshAccessToken();
            if (refresh) {
              String? accessToken = await Token.readAccessToken();
              if (accessToken != null) {
                bool verified = await Token.verifyToken(accessToken!);
                if (verified) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Dashboard_Page())
                  );
                }
                else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }
              }
            }
          }
        }
      }
    }
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
