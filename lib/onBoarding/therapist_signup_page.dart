import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Widgets/custom_button.dart';
import 'therapist_login_page.dart';

class TherapistSignupPage extends StatelessWidget {
  const TherapistSignupPage({super.key});

  void _showPopup(BuildContext context, String message, {bool success = false}) {
    if (!Get.isDialogOpen!) {
      Get.dialog(
        Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: success ? Colors.green.withOpacity(0.85) : Colors.red.withOpacity(0.85),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        barrierColor: Colors.black.withOpacity(0.3),
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (Get.isDialogOpen ?? false) Get.back();
      });
    }
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5DBAC), Color(0xFFFFE4E1)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset("assets/ai3.png", height: 200),
                  const SizedBox(height: 20),
                  Text(
                    "Therapist Sign Up ✨",
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      shadows: const [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.brown,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Glassmorphic card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.brown.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: nameController,
                          style: const TextStyle(color: Color(0xFF000000)),
                          decoration: const InputDecoration(
                            hintText: "Full Name",
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.person, color: Colors.black),
                          ),
                        ),
                        const Divider(color: Colors.black54),
                        TextField(
                          controller: emailController,
                          style: const TextStyle(color: Color(0xFF000000)),
                          decoration: const InputDecoration(
                            hintText: "Email",
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.email, color: Colors.black),
                          ),
                        ),
                        const Divider(color: Colors.black54),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          style: const TextStyle(color: Color(0xFF000000)),
                          decoration: const InputDecoration(
                            hintText: "Password",
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.lock, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),
                  CustomButton(
                    text: "Sign Up",
                    onPressed: () async {
                      final name = nameController.text.trim();
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();

                      if (name.isEmpty || email.isEmpty || password.isEmpty) {
                        _showPopup(context, "All fields are required!");
                        return;
                      }
                      if (!_isValidEmail(email)) {
                        _showPopup(context, "Please enter a valid email!");
                        return;
                      }
                      if (password.length < 6) {
                        _showPopup(context, "Password must be at least 6 characters!");
                        return;
                      }

                      try {
                        UserCredential userCredential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(email: email, password: password);

                        if (userCredential.user != null) {
                          await FirebaseFirestore.instance
                              .collection("therapists")
                              .doc(userCredential.user!.uid)
                              .set({"fullName": name, "email": email});

                          _showPopup(context, "Signup successful!", success: true);
                          Future.delayed(const Duration(seconds: 2), () {
                            Get.off(() => const TherapistLoginPage(),
                                transition: Transition.rightToLeftWithFade,
                                duration: const Duration(milliseconds: 600));
                          });
                        }
                      } on FirebaseAuthException catch (e) {
                        _showPopup(context, e.message ?? "Signup failed");
                      }
                    },
                  ),

                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () => Get.to(() => const TherapistLoginPage(),
                        transition: Transition.rightToLeftWithFade),
                    child: Text(
                      "Already have an account? Login",
                      style: GoogleFonts.kaushanScript(
                        fontSize: 16,
                        color: Colors.black87,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
