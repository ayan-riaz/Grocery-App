import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/widgets/wrapper.dart';
import 'package:get/get.dart';

class EmailVerifyScreen extends StatefulWidget {
  const EmailVerifyScreen({super.key});

  @override
  State<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen> {
  @override
  void initState() {
    sendVerifyLink();
    super.initState();
  }

  void sendVerifyLink() async {
    final user = FirebaseAuth.instance.currentUser;
    await user!.sendEmailVerification().then((value) => Get.snackbar(
          "Email Verification",
          "A verification email has been sent to ${user.email}. Please verify your email.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        ));
  }

  void reload() async {
    await FirebaseAuth.instance.currentUser!
        .reload()
        .then((value) => Get.offAll(const Wrapper()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please verify your email address',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: reload,
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              label: const Text('reload',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 2, 160, 120),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
