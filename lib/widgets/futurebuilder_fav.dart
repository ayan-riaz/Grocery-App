import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/screens/favourite_screen.dart';

class FuturebuilderFav extends StatefulWidget {
  const FuturebuilderFav({super.key});

  @override
  State<FuturebuilderFav> createState() => _FuturebuilderFavState();
}

class _FuturebuilderFavState extends State<FuturebuilderFav> {
  getData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    var result = await FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .collection('Favourite')
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
            return FavouriteScreen(
              snapshot: snapshot,
            );
          }
          return const Center(child: Text('No Data'));
        });
  }
}
