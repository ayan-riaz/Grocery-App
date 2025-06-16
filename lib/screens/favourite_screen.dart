import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/widgets/drawer_widget.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key, required this.snapshot});
  final QuerySnapshot snapshot;

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  late List<QueryDocumentSnapshot> docs;

  @override
  void initState() {
    super.initState();
    docs = widget.snapshot.docs;
  }

void removeFromFavourites(String id) async {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  await FirebaseFirestore.instance
      .collection('Users')
      .doc(userId)
      .collection('Favourite')
      .doc(id)
      .delete();

  setState(() {
    docs.removeWhere((doc) => doc.id == id);
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
        centerTitle: true,
      ),
      drawer: const DrawerWidget(),
      body: docs.isEmpty
          ? const Center(child: Text("No favourites yet."))
          : ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                return Dismissible(
                  key: Key(doc.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    removeFromFavourites(doc.id);
                  },
                  child: ListTile(
                    title: Text(doc['name']),
                    subtitle: Text(doc['description']),
                    trailing: Text('\$${doc['price']}'),
                    leading: SizedBox(
                      height: 80,
                      width: 80,
                      child: Image.network(
                        doc['imageUrl'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
