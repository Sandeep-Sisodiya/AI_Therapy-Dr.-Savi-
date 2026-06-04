import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../app_theme.dart';
import '../Widgets/custom_button.dart';
import 'therapist_login_page.dart';

class TherapistSignupPage extends StatelessWidget {
  const TherapistSignupPage({super.key});

  void _showPopup(BuildContext context, String message, {bool success = false}) {
    if (!Get.isDialogOpen!) {
      Get.dialog(
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: (success ? AppColors.auroraTeal : AppColors.errorRed)
                      .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: (success ? AppColors.auroraTeal : AppColors.errorRed)
                        .withOpacity(0.4),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      success ? Icons.check_circle_rounded : Icons.error_rounded,
                      color: success ? AppColors.auroraTeal : AppColors.errorRed,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        message,
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.starWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        barrierColor: Colors.black.withOpacity(0.4),
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
          gradient: AppGradients.backgroundGradient,
        ),
        child: Stack(
          children: [
            Positioned(
              top: -40,
              right: -30,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.auroraTeal.withOpacity(0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Image.asset("assets/ai3.png", height: 170)
                          .animate()
                          .fadeIn(duration: 600.ms),
                      const SizedBox(height: 20),

                      Text(
                        "Therapist Sign Up ✨",
                        style: AppTypography.displayMedium,
                      ).animate().fadeIn(delay: 200.ms, duration: 500.ms),

                      const SizedBox(height: 6),
                      Text(
                        "Create your professional account",
                        style: AppTypography.bodyMedium,
                      ).animate().fadeIn(delay: 300.ms, duration: 500.ms),

                      const SizedBox(height: 34),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: GlassDecoration.accentCard(
                              glowColor: AppColors.auroraTeal,
                              borderRadius: 22,
                            ),
                            child: Column(
                              children: [
                                TextField(
                                  controller: nameController,
                                  style: AppTypography.bodyLarge,
                                  decoration: InputDecoration(
                                    hintText: "Full Name",
                                    prefixIcon: Icon(Icons.person_rounded,
                                        color: AppColors.auroraTeal),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                                Divider(color: AppColors.glassBorder, height: 1),
                                TextField(
                                  controller: emailController,
                                  style: AppTypography.bodyLarge,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    prefixIcon: Icon(Icons.email_rounded,
                                        color: AppColors.auroraTeal),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                                Divider(color: AppColors.glassBorder, height: 1),
                                TextField(
                                  controller: passwordController,
                                  obscureText: true,
                                  style: AppTypography.bodyLarge,
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    prefixIcon: Icon(Icons.lock_rounded,
                                        color: AppColors.auroraTeal),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ).animate().fadeIn(delay: 400.ms, duration: 500.ms),

                      const SizedBox(height: 28),

                      CustomButton(
                        text: "Sign Up",
                        color: AppColors.auroraTeal,
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
                                .createUserWithEmailAndPassword(
                                    email: email, password: password);

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
                      ).animate().fadeIn(delay: 500.ms, duration: 500.ms),

                      const SizedBox(height: 22),
                      GestureDetector(
                        onTap: () => Get.to(() => const TherapistLoginPage(),
                            transition: Transition.rightToLeftWithFade),
                        child: RichText(
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: AppTypography.bodyMedium,
                            children: [
                              TextSpan(
                                text: "Login",
                                style: AppTypography.labelMedium.copyWith(
                                  color: AppColors.auroraTeal,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.auroraTeal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: 600.ms, duration: 500.ms),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
