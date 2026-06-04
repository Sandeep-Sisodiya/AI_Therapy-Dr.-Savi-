import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../app_theme.dart';
import '../Widgets/custom_button.dart';
import 'login_page.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    final regex = RegExp(r'^(?=.*[!@#\$&*~]).{6,}$');
    return regex.hasMatch(password);
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

  @override
  Widget build(BuildContext context) {
    final fullNameController = TextEditingController();
    final nicknameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

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
              left: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.auroraRose.withOpacity(0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -60,
              right: -30,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.auroraLavender.withOpacity(0.08),
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
                      Image.asset("assets/ai3.png", height: 130)
                          .animate()
                          .fadeIn(duration: 600.ms),
                      const SizedBox(height: 20),

                      Text(
                        "Create Account ✨",
                        style: AppTypography.displayMedium,
                      ).animate().fadeIn(delay: 200.ms, duration: 500.ms),

                      const SizedBox(height: 6),
                      Text(
                        "Begin your wellness journey",
                        style: AppTypography.bodyMedium,
                      ).animate().fadeIn(delay: 300.ms, duration: 500.ms),

                      const SizedBox(height: 30),

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
                                _buildField(fullNameController, "Full Name", Icons.badge_rounded),
                                _divider(),
                                _buildField(nicknameController, "Nickname", Icons.person_rounded),
                                _divider(),
                                _buildField(emailController, "Email", Icons.email_rounded,
                                    keyboardType: TextInputType.emailAddress),
                                _divider(),
                                _buildField(passwordController, "Password", Icons.lock_rounded,
                                    obscure: true),
                                _divider(),
                                _buildField(confirmPasswordController, "Confirm Password",
                                    Icons.lock_outline_rounded,
                                    obscure: true),
                              ],
                            ),
                          ),
                        ),
                      ).animate().fadeIn(delay: 400.ms, duration: 500.ms),

                      const SizedBox(height: 28),

                      CustomButton(
                        text: "Sign Up",
                        onPressed: () async {
                          final fullName = fullNameController.text.trim();
                          final nickname = nicknameController.text.trim();
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();
                          final confirmPassword = confirmPasswordController.text.trim();

                          if (fullName.isEmpty || nickname.isEmpty || email.isEmpty ||
                              password.isEmpty || confirmPassword.isEmpty) {
                            _showPopup(context, "All fields are required!");
                            return;
                          }
                          if (!_isValidEmail(email)) {
                            _showPopup(context, "Please enter a valid email!");
                            return;
                          }
                          if (!_isValidPassword(password)) {
                            _showPopup(context, "Password must be 6+ characters & include a symbol!");
                            return;
                          }
                          if (password != confirmPassword) {
                            _showPopup(context, "Passwords do not match!");
                            return;
                          }

                          try {
                            UserCredential userCredential =
                                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: email,
                              password: password,
                            );

                            if (userCredential.user != null) {
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(userCredential.user!.uid)
                                  .set({
                                "fullName": fullName,
                                "nickname": nickname,
                                "email": email,
                              });

                              _showPopup(context, "Account created successfully!", success: true);

                              Future.delayed(const Duration(seconds: 2), () {
                                Get.off(
                                  () => const LoginPage(),
                                  transition: Transition.leftToRightWithFade,
                                  duration: const Duration(milliseconds: 600),
                                );
                              });
                            }
                          } on FirebaseAuthException catch (e) {
                            _showPopup(context, e.message ?? "Signup failed");
                          }
                        },
                      ).animate().fadeIn(delay: 500.ms, duration: 500.ms),

                      const SizedBox(height: 22),

                      GestureDetector(
                        onTap: () => Get.to(() => const LoginPage(),
                            transition: Transition.rightToLeftWithFade),
                        child: RichText(
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: AppTypography.bodyMedium,
                            children: [
                              TextSpan(
                                text: "Login",
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

  Widget _buildField(TextEditingController controller, String hint, IconData icon,
      {bool obscure = false, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: AppTypography.bodyLarge,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }

  Widget _divider() => Divider(color: AppColors.glassBorder, height: 1);
}
