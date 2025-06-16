import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/screens/cart_screen.dart';

class FuturebuilderCart extends StatefulWidget {
  const FuturebuilderCart({super.key});

  @override
  State<FuturebuilderCart> createState() => _FuturebuilderCartState();
}

class _FuturebuilderCartState extends State<FuturebuilderCart> {
  final userid = FirebaseAuth.instance.currentUser!.uid;
  getData() async {
    final result = await FirebaseFirestore.instance
        .collection("Users")
        .doc(userid)
        .collection('Cart')
        .get();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, dynamic snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error'));
        }
        if (snapshot.hasData) {
          return CartScreen(snapshot: snapshot);
        }
        return const Center(child: Text('No Data Available'));
      },
    );
  }
}
