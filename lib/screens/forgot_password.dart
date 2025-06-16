import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var emailEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var enteredEmail = '';

  @override
  void dispose() {
    emailEditingController.dispose();
    super.dispose();
  }

  void resetPassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: emailEditingController.text,
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
            children: [
              const Text('Forgot Password',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  )),
              const SizedBox(height: 20),
              Form(
                key: formKey,
                child: Column(
                  children: [
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            const Color.fromARGB(255, 2, 160, 120),
                        elevation: 3,
                        shadowColor: Colors.black,
                        fixedSize: const Size(300, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                      ),
                      onPressed: resetPassword,
                      child: const Text('Reset Password',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          )),
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
