import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/screens/login_screen.dart';
import 'package:food_app/widgets/wrapper.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() {
    return SignupScreenState();
  }
}

class SignupScreenState extends State<SignupScreen> {
  var _isObscured = true;
  var nameEditingController = TextEditingController();
  var emailEditingController = TextEditingController();
  var passwordEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var enteredName = '';
  var enteredEmail = '';
  var enteredPassword = '';
  var isLoading = false;

  @override
  void dispose() {
    emailEditingController.dispose();
    passwordEditingController.dispose();
    super.dispose();
  }

  void signup() async {
    setState(() {
      isLoading = true;
    });
    if (!formKey.currentState!.validate()) {
      return;
    }
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailEditingController.text,
      password: passwordEditingController.text,
    );
    Get.offAll(const Wrapper());
    setState(() {
      isLoading = false;
    });
  }

  void signin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? const Center(child: CircularProgressIndicator(),) : Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    const Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Let's Create account together",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    // TextFormField(
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return "Please enter your full name.";
                    //     }
                    //     return null;
                    //   },
                    //   onSaved: (value) {
                    //     if (value != null) {
                    //       enteredName = value;
                    //     }
                    //   },
                    //   controller: nameEditingController,
                    //   decoration: const InputDecoration(
                    //     labelText: 'Full Name',
                    //     filled: true,
                    //     fillColor: Color.fromARGB(255, 236, 236, 236),
                    //     border: OutlineInputBorder(
                    //       borderSide: BorderSide.none,
                    //       borderRadius: BorderRadius.all(Radius.circular(8)),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 20),
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
                        labelText: 'Email',
                        filled: true,
                        fillColor: Color.fromARGB(255, 236, 236, 236),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
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
                      onPressed: signup,
                      child: const Text(
                        textAlign: TextAlign.center,
                        "Sign up",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already Have An Account?",
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 1,
                        vertical: 1,
                      ),
                    ),
                    onPressed: signin,
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        color: Color.fromARGB(255, 2, 160, 120),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
