import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../app_theme.dart';
import '../Widgets/custom_button.dart';
import 'login_page.dart';
import 'therapist_login_page.dart';

class UserTherapistChoicePage extends StatelessWidget {
  const UserTherapistChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppGradients.backgroundGradient,
        ),
        child: Stack(
          children: [
            // Ambient glow behind robot
            Positioned(
              top: Get.height * 0.08,
              left: Get.width * 0.5 - 140,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.auroraLavender.withOpacity(0.12),
                      AppColors.auroraRose.withOpacity(0.04),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Bottom ambient glow
            Positioned(
              bottom: -60,
              right: -40,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.auroraTeal.withOpacity(0.06),
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
                      const SizedBox(height: 40),
                      // Robot image with glow
                      Image.asset("assets/robot.png", height: 320)
                          .animate()
                          .fadeIn(duration: 800.ms)
                          .slideY(begin: -0.1, end: 0, duration: 800.ms),
                      const SizedBox(height: 16),

                      // Title
                      Text(
                        "Continue as",
                        style: AppTypography.displayLarge,
                      )
                          .animate()
                          .fadeIn(delay: 300.ms, duration: 600.ms),

                      const SizedBox(height: 32),

                      // Glass card with role buttons
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: GlassDecoration.card(borderRadius: 24),
                            child: Column(
                              children: [
                                // User button
                                _RoleOptionCard(
                                  icon: Icons.person_rounded,
                                  title: "User",
                                  subtitle: "Seek AI therapy & support",
                                  accentColor: AppColors.auroraLavender,
                                  onTap: () {
                                    Get.to(() => const LoginPage(),
                                        transition: Transition.rightToLeftWithFade);
                                  },
                                )
                                    .animate()
                                    .fadeIn(delay: 500.ms, duration: 500.ms)
                                    .slideX(begin: -0.1, end: 0),

                                const SizedBox(height: 16),

                                // Therapist button
                                _RoleOptionCard(
                                  icon: Icons.medical_services_rounded,
                                  title: "Therapist",
                                  subtitle: "Manage your practice",
                                  accentColor: AppColors.auroraTeal,
                                  onTap: () {
                                    Get.to(() => const TherapistLoginPage(),
                                        transition: Transition.rightToLeftWithFade);
                                  },
                                )
                                    .animate()
                                    .fadeIn(delay: 650.ms, duration: 500.ms)
                                    .slideX(begin: -0.1, end: 0),
                              ],
                            ),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 400.ms, duration: 600.ms),

                      const SizedBox(height: 80),
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

class _RoleOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final VoidCallback onTap;

  const _RoleOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: accentColor.withOpacity(0.25),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: accentColor, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.headlineLarge.copyWith(
                      color: AppColors.starWhite,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: accentColor.withOpacity(0.6),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
