import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/screens/admin_login.dart';
import 'package:food_app/screens/signup_screen.dart';
import 'package:food_app/widgets/wrapper.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() {
    return SignInScreenState();
  }
}

class SignInScreenState extends State<SignInScreen> {
  var _isObscured = true;
  var emailEditingController = TextEditingController();
  var passwordEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var enteredEmail = '';
  var enteredPassword = '';

  @override
  void dispose() {
    emailEditingController.dispose();
    passwordEditingController.dispose();
    super.dispose();
  }

  void signIn() async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailEditingController.text,
        password: passwordEditingController.text,
      );
      Get.offAll(const Wrapper());
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error Message", e.code);
    } catch (e) {
      Get.snackbar("Error Message", e.toString());
    }
  }

  void signUp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignupScreen()),
    );
  }

  void adminLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminLogin()),
    );
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
                      "Hello Again!",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Welcome Back You Have Been Missed!",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
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
                      onPressed: signIn,
                      child: const Text(
                        textAlign: TextAlign.center,
                        "Sign In",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't Have An Account?",
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                          onPressed: signUp,
                          child: const Text(
                            'Sign Up for Free',
                            style: TextStyle(
                              color: Color.fromARGB(255, 2, 160, 120),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Login In as",
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                          onPressed: adminLogin,
                          child: const Text(
                            'Admin',
                            style: TextStyle(
                                fontSize: 17,
                                color: Color.fromARGB(255, 2, 160, 120)),
                          ),
                        ),
                      ],
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
