import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app_theme.dart';
import '../Widgets/custom_button.dart';
import 'on_boarding.dart';
import 'signup_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

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
                  color: (success
                          ? AppColors.auroraTeal
                          : AppColors.errorRed)
                      .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: (success
                            ? AppColors.auroraTeal
                            : AppColors.errorRed)
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

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppGradients.backgroundGradient,
        ),
        child: Stack(
          children: [
            // Ambient glows
            Positioned(
              top: -60,
              right: -40,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.auroraLavender.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -50,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.auroraRose.withOpacity(0.06),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset("assets/ai3.png", height: 180)
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
                      const SizedBox(height: 24),

                      Text(
                        "Welcome Back 👋",
                        style: AppTypography.displayMedium,
                      ).animate().fadeIn(delay: 200.ms, duration: 500.ms),

                      const SizedBox(height: 8),
                      Text(
                        "Sign in to continue your journey",
                        style: AppTypography.bodyMedium,
                      ).animate().fadeIn(delay: 300.ms, duration: 500.ms),

                      const SizedBox(height: 36),

                      // Glass input card
                      ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: GlassDecoration.card(borderRadius: 22),
                            child: Column(
                              children: [
                                TextField(
                                  controller: emailController,
                                  style: AppTypography.bodyLarge,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    prefixIcon: const Icon(Icons.email_rounded),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                                Divider(
                                  color: AppColors.glassBorder,
                                  height: 1,
                                ),
                                TextField(
                                  controller: passwordController,
                                  obscureText: true,
                                  style: AppTypography.bodyLarge,
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    prefixIcon: const Icon(Icons.lock_rounded),
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

                      const SizedBox(height: 30),

                      CustomButton(
                        text: "Login",
                        onPressed: () async {
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

                          try {
                            // ✅ Firebase Sign In
                            UserCredential userCredential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(email: email, password: password);

                            if (userCredential.user != null) {
                              _showPopup(context, "Login successful!", success: true);

                              Future.delayed(const Duration(seconds: 2), () {
                                Get.off(
                                  () => const OnBoarding(),
                                  transition: Transition.rightToLeftWithFade,
                                  duration: const Duration(milliseconds: 600),
                                );
                              });
                            }
                          } on FirebaseAuthException catch (e) {
                            _showPopup(context, e.message ?? "Login failed");
                          }
                        },
                      ).animate().fadeIn(delay: 500.ms, duration: 500.ms),

                      const SizedBox(height: 24),

                      GestureDetector(
                        onTap: () => Get.to(
                          () => const SignupPage(),
                          transition: Transition.rightToLeftWithFade,
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: AppTypography.bodyMedium,
                            children: [
                              TextSpan(
                                text: "Sign Up",
                                style: AppTypography.labelMedium.copyWith(
                                  color: AppColors.auroraRose,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.auroraRose,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: 600.ms, duration: 500.ms),
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
