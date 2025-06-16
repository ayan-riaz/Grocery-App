import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_app/screens/onboard_screen.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx)=> OnboardScreen()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: const Color.fromARGB(255, 2, 160, 120),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo2.png',
                width: 200,
                height: 200,
              ),
              const Text('Fresh Fare',style: TextStyle(fontSize: 15,color: Colors.white, fontWeight: FontWeight.bold),)
            ],
          ),
        ),
      ),
    );
  }
}
