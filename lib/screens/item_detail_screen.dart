import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/model/items_model.dart';
import 'package:get/get.dart';

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({super.key, required this.itemsModel});
  final ItemsModel itemsModel;

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  var sliderValue = 1;
  var isSending = false;
  var isFavorite = false;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  void addFavourite() async {
    if (isFavorite) return;

    await FirebaseFirestore.instance.collection('Users').doc(userId).collection('Favourite').add({
      'imageUrl': widget.itemsModel.imageUrl,
      'name': widget.itemsModel.title,
      'description': widget.itemsModel.description,
      'category': widget.itemsModel.category.name,
      'price': widget.itemsModel.price,
    });
    setState(() {
      isFavorite = true;
    });
    Get.snackbar(
      'Added to Favourites',
      'You have added ${widget.itemsModel.title} to your favourites.',
      backgroundColor: const Color.fromARGB(255, 2, 160, 120),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void initState() {
    super.initState();
    checkIfFavourite();
  }

  void checkIfFavourite() async {
  final favs = await FirebaseFirestore.instance
      .collection('Users')
      .doc(userId)
      .collection('Favourite')
      .where('name', isEqualTo: widget.itemsModel.title)
      .get();
      
  if (favs.docs.isNotEmpty) {
    setState(() {
      isFavorite = true;
    });
  }
}

  void addToCart() async {
    final totalprice = (widget.itemsModel.price * sliderValue);
    await FirebaseFirestore.instance.collection("Users").doc(userId).collection('Cart').add({
      'imageUrl': widget.itemsModel.imageUrl,
      'name': widget.itemsModel.title,
      'description': widget.itemsModel.description,
      'category': widget.itemsModel.category.name,
      'price': widget.itemsModel.price,
      'totalItems': sliderValue,
      'totalPrice': (totalprice),
    });
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('details'),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: addFavourite,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: Image.network(widget.itemsModel.imageUrl).image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(widget.itemsModel.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 10),
            Text(
              widget.itemsModel.description,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                showValueIndicator: ShowValueIndicator.always,
                valueIndicatorTextStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
              child: Slider(
                value: sliderValue.toDouble(),
                min: 1,
                max: 20,
                label: sliderValue.toString(),
                activeColor: const Color.fromARGB(255, 2, 160, 120),
                inactiveColor:
                    const Color.fromARGB(255, 2, 160, 120).withOpacity(0.3),
                thumbColor: const Color.fromARGB(255, 2, 160, 120),
                onChanged: (value) {
                  setState(() {
                    sliderValue = value.toInt();
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Items',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  sliderValue.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Price',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${(widget.itemsModel.price * sliderValue)} Rs".toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              widget.itemsModel.price.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 10,
        onPressed: isSending ? null : addToCart,
        backgroundColor: const Color.fromARGB(255, 2, 160, 120),
        label: isSending
            ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(),
              )
            : const Text(
                'Add to Cart',
                style: TextStyle(color: Colors.white),
              ),
        icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
