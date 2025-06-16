import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/screens/email_verify_screen.dart';
import 'package:food_app/screens/login_screen.dart';
import 'package:food_app/widgets/tabs.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            if(snapshot.data!.emailVerified){
              return const TabsScreen();
            }
            else{
              return const EmailVerifyScreen();
            }
            
          } else {
            return const SignInScreen();
          }
        },
      ),
    );
  }
}
