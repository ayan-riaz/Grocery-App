import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/screens/NotificationScreen.dart';
import 'package:food_app/services/notification_services.dart';
import 'package:food_app/widgets/drawer_widget.dart';
import 'package:food_app/widgets/grid_builder.dart';
import 'package:food_app/model/items_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Category? selectedCategory;

  void _selectCategory(Category? category) {
    setState(() {
      selectedCategory = category;
    });
  }

  final user = FirebaseAuth.instance.currentUser;
  final Map<Category?, String> categoryLabels = {
    null: 'All',
    Category.vegetable: 'Vegetable',
    Category.fruit: 'Fruit',
    Category.meat: 'Meat',
    Category.other: 'Other',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) =>
                        NotificationScreen(notifications: notifications)),
              );
            },
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                suffixIcon:
                    Icon(Icons.search, color: Color.fromARGB(255, 2, 160, 120)),
                hintText: 'Search',
                filled: true,
                fillColor: Color.fromARGB(255, 236, 236, 236),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categoryLabels.entries.map((entry) {
                  final isSelected = selectedCategory == entry.key;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ElevatedButton(
                      onPressed: () => _selectCategory(entry.key),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? const Color.fromARGB(255, 2, 160, 120)
                            : Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                      ),
                      child: Text(
                        entry.value,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color.fromARGB(255, 2, 160, 120),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
                child: GridBuilder(
              category: selectedCategory,
            )),
          ],
        ),
      ),
    );
  }
}
