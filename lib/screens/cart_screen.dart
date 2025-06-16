import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/services/stripe_service.dart';
import 'package:food_app/widgets/drawer_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, required this.snapshot});
  final QuerySnapshot snapshot;
  @override
  State<CartScreen> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState extends State<CartScreen> {
  late final List docs;
  int totalAmount = 0;

  @override
  void initState() {
    super.initState();
    docs = widget.snapshot.docs;
    calculateTotal();
  }

  void calculateTotal() {
    totalAmount = 0;
    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      if (data.containsKey('totalPrice')) {
        totalAmount += (data['totalPrice'] as num).toInt();
      }
    }
  }

  void removeFromFavourites(String id) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Cart')
        .doc(id)
        .delete();
    setState(() {
      docs.removeWhere((doc) => doc.id == id);
      calculateTotal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        centerTitle: true,
      ),
      drawer: const DrawerWidget(),
      body: Column(
        children: [
          Expanded(
            child: docs.isEmpty
                ? const Center(child: Text('Your cart is empty.'))
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
                          trailing: Text('${doc['totalPrice']}Rs'),
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
          ),
          const SizedBox(height: 20),
          Text(
            "$totalAmount Rs",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 2, 160, 120),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 2, 160, 120),
                elevation: 5,
                shadowColor: Colors.black,
                fixedSize: const Size(400, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
              ),
              onPressed: () {
                int cartTotalPKR = totalAmount;

                if (cartTotalPKR < 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Minimum order should be ₨200")),
                  );
                  return;
                }

                StripeService.instance.makePaymentInPKR(cartTotalPKR);
              },
              child: const Text(
                textAlign: TextAlign.center,
                "Checkout",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
