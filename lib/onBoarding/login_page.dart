import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Widgets/custom_button.dart';
import '../custom_background.dart';
import 'on_boarding.dart';
import 'signup_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  void _showPopup(BuildContext context, String message, {bool success = false}) {
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

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: true, // fixes keyboard overflow
      body: CustomBackground(
        otherWidget: Padding(
          padding: const EdgeInsets.all(25),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset("assets/ai3.png", height: 200),
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    "Welcome Back 👋",
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      shadows: [
                        const Shadow(
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
                          controller: emailController,
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
                    text: "Login",
                    onPressed: () {
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();

                      if (email.isEmpty || password.isEmpty) {
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

                      // Success
                      _showPopup(context, "Login successful!", success: true);

                      Future.delayed(const Duration(seconds: 2), () {
                        Get.off(
                              () => const OnBoarding(),
                          transition: Transition.rightToLeftWithFade,
                          duration: const Duration(milliseconds: 600),
                        );
                      });
                    },
                  ),

                  const SizedBox(height: 15),

                  GestureDetector(
                    onTap: () => Get.to(() => const SignupPage(),
                        transition: Transition.rightToLeftWithFade),
                    child: Text(
                      "Don’t have an account? Sign Up",
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
