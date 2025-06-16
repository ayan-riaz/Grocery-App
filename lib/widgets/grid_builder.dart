import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:food_app/model/items_model.dart';
import 'package:food_app/screens/item_detail_screen.dart';

class GridBuilder extends StatefulWidget {
  final Category? category;

  const GridBuilder({super.key, required this.category});

  @override
  State<GridBuilder> createState() => _GridBuilderState();
}

class _GridBuilderState extends State<GridBuilder> {
  List<ItemsModel> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  @override
  void didUpdateWidget(covariant GridBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.category != widget.category) {
      fetchItems(); 
    }
  }

  Future<void> fetchItems() async {
    setState(() => isLoading = true);

    try {
      final snapshot = await FirebaseFirestore.instance.collection('foods').get();

      final allItems = snapshot.docs.map((doc) {
        final data = doc.data();
        return ItemsModel(
          id: doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          price: double.tryParse(data['price'].toString()) ?? 0.0,
          imageUrl: data['imageUrl'] ?? '',
          category: Category.values.firstWhere(
            (cat) => cat.name == data['category'],
            orElse: () => Category.other,
          ),
        );
      }).toList();

      final filteredItems = widget.category == null
          ? allItems
          : allItems.where((item) => item.category == widget.category).toList();

      setState(() {
        items = filteredItems;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching items: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (items.isEmpty) {
      return const Center(child: Text("No items found."));
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemDetailScreen(itemsModel: item),
              ),
            );
          },
          child: Material(
            elevation: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              margin: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: Image.network(item.imageUrl, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 8),
                  Text(item.title),
                  Text(
                    'Rs. ${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
