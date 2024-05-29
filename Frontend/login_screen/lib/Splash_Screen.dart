import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this for SystemNavigator.pop
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
    try {
      await handleTokenVerification(); // Call your asynchronous logic here
    } catch (error) {
      _showErrorDialog('Network Error', 'Failed to connect to the server. Please try again.');
    }
  }

  Future<void> handleTokenVerification() async {
    // Read AccessToken & Check validity and route to Dashboard
    String? accessToken = await Token.readAccessToken();
    if (accessToken != null) {
      bool verified = await Token.verifyToken(accessToken);
      if (verified) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashboard_Page())
        );
        return;
      } else {
        String? refreshToken = await Token.readRefreshToken();
        if (refreshToken != null) {
          bool verified = await Token.verifyToken(refreshToken);
          if (verified) {
            bool refresh = await Token.refreshAccessToken();
            if (refresh) {
              String? newAccessToken = await Token.readAccessToken();
              if (newAccessToken != null) {
                bool verified = await Token.verifyToken(newAccessToken);
                if (verified) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Dashboard_Page())
                  );
                  return;
                }
              }
            }
          }
        }
      }
    }
    throw Exception("Token verification failed");
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Retry'),
              onPressed: () {
                Navigator.of(context).pop();
                _handleTokenVerification();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                SystemNavigator.pop(); // Close the app
              },
            ),
          ],
        );
      },
    );
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
          height: double.infinity,
        ),
      ),
    );
  }
}
