import 'package:bluestone_app/constants/colors.dart';
import 'package:bluestone_app/screens/login_screen/login_screen.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });

    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.diamond, size: 100, color: ColorClass.darkBlue),
            SizedBox(height: 20),
            Text(
              'Bluestone App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
