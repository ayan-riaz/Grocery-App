import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class DrawerWidget extends StatefulWidget{
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  void signOut() async{
    await FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hello User'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          
        ],
      ),
    );
  }
}