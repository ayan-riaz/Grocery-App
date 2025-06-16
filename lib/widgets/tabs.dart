import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/screens/cart_screen.dart';
import 'package:food_app/screens/favourite_screen.dart';
import 'package:food_app/screens/home_screen.dart';
import 'package:food_app/screens/profile_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int selectedPageIndex = 0;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  void _selectPage(int index) {
    setState(() {
      selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const HomeScreen();

    if (selectedPageIndex == 1) {
      activePage = FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection("Users") 
            .doc(userId)
            .collection('Favourite')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading favourites'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No favourites yet.'));
          }
          return FavouriteScreen(snapshot: snapshot.data!);
        },
      );
    }

    if (selectedPageIndex == 2) {
  activePage = FutureBuilder<QuerySnapshot>(
    future: FirebaseFirestore.instance
      .collection("Users")
      .doc(userId)
      .collection('Cart') 
      .get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return const Center(child: Text('Error loading cart'));
      }
      return CartScreen(snapshot: snapshot.data!);
    },
  );
}

    if (selectedPageIndex == 3) {
      activePage = const ProfileScreen();
    }

    return Scaffold(
      body: activePage,
      bottomNavigationBar: CurvedNavigationBar(
        index: selectedPageIndex,
        height: 60.0,
        backgroundColor: Colors.transparent,
        color: const Color.fromARGB(255, 2, 160, 120),
        animationDuration: const Duration(milliseconds: 300),
        onTap: _selectPage,
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.favorite, size: 30, color: Colors.white),
          Icon(Icons.shopping_bag, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
      ),
    );
  }
}
