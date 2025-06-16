import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_app/widgets/image_picker.dart';
import 'package:food_app/model/items_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminDetailScreen extends StatefulWidget {
  const AdminDetailScreen({super.key});

  @override
  State<AdminDetailScreen> createState() => _AdminDetailScreenState();
}

class _AdminDetailScreenState extends State<AdminDetailScreen> {
  var titleEditingController = TextEditingController();
  var descriptionEditingController = TextEditingController();
  var priceEditingController = TextEditingController();
  var enteredTitle = '';
  var enteredDescription = '';
  var enteredPrice = '';
  File? _pickedImage;
  Category _selectedCategory = Category.vegetable;

  Future<void> addItem() async {
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please pick an image.')),
      );
      return;
    }

    final enteredTitle = titleEditingController.text;
    final enteredDescription = descriptionEditingController.text;
    final enteredPrice = priceEditingController.text;

    try {
      final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/drvvmee5y/image/upload',
      );

      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'food_app'
        ..files.add(
          await http.MultipartFile.fromPath('file', _pickedImage!.path),
        );

      final response = await request.send();

      if (response.statusCode != 200) {
        throw Exception('Cloudinary upload failed');
      }

      final resData = await http.Response.fromStream(response);
      final responseData = jsonDecode(resData.body);
      final imageUrl = responseData['secure_url'];

      await FirebaseFirestore.instance.collection('foods').add({
        'title': enteredTitle,
        'description': enteredDescription,
        'price': enteredPrice,
        'category': _selectedCategory.name,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Success',
        'Item added successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add item: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Details'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImageInput(
                  onPickImage: (image) {
                    _pickedImage = image;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter Title.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null) {
                      enteredTitle = value.toString();
                    }
                  },
                  controller: titleEditingController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 236, 236, 236),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    labelText: 'Title',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter Description.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null) {
                      enteredDescription = value.toString();
                    }
                  },
                  controller: descriptionEditingController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 236, 236, 236),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    labelText: 'Description',
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! <= 0) {
                            return "Please enter your email address.";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          if (value != null) {
                            enteredPrice = value.toString();
                          }
                        },
                        controller: priceEditingController,
                        keyboardType: const TextInputType.numberWithOptions(),
                        decoration: const InputDecoration(
                          prefixText: "Rs",
                          filled: true,
                          fillColor: Color.fromARGB(255, 236, 236, 236),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          labelText: 'Price',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<Category>(
                        value: _selectedCategory,
                        items: Category.values.map((Category category) {
                          return DropdownMenuItem<Category>(
                            value: category,
                            child: Text(category.name),
                          );
                        }).toList(),
                        onChanged: (Category? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedCategory = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 2, 160, 120),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                        ),
                        onPressed: addItem,
                        child: const Text(
                          'Add',
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
