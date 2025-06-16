import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/details_screen/admin_detail_screen.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';


class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  var formKey = GlobalKey<FormState>();
  var _isObscured = true;
  var emailEditingController = TextEditingController();
  var passwordEditingController = TextEditingController();
  var enteredEmail = '';
  var enteredPassword = '';

  @override
  void dispose() {
    emailEditingController.dispose();
    passwordEditingController.dispose();
    super.dispose();
  }
  void signin() async {
  if (!formKey.currentState!.validate()) return;

  formKey.currentState!.save();

  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailEditingController.text,
      password: passwordEditingController.text,
    );

    if (!mounted) return; // 🧠 this ensures the widget is still in the widget tree

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AdminDetailScreen()),
    );
  } catch (e) {
    Get.snackbar(
      'Login Failed',
      e.toString(),
      backgroundColor: const Color.fromARGB(255, 2, 160, 120),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    const Text(
                      "Login Admin",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email address.";
                        } else if (!RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                            .hasMatch(value)) {
                          return "Enter a valid email (e.g., user@example.com).";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        if (value != null) {
                          enteredEmail = value;
                        }
                      },
                      controller: emailEditingController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 236, 236, 236),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        labelText: 'Email',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password.";
                        } else if (value.length < 8) {
                          return "Password must be at least 8 characters.";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        if (value != null) {
                          enteredPassword = value;
                        }
                      },
                      controller: passwordEditingController,
                      obscureText: _isObscured,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 236, 236, 236),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscured
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromARGB(255, 2, 160, 120),
                        fixedSize: const Size(400, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                      ),
                      onPressed: signin,
                      child: const Text(
                        textAlign: TextAlign.center,
                        "Sign In",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
