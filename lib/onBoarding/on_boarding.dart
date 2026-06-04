import 'package:ai_therapy/Widgets/custom_button.dart';
import 'package:ai_therapy/onBoarding/select_user_issues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';
import 'package:get/get.dart';

import '../app_theme.dart';
import '../custom_background.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        otherWidget: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 10),
                // Robot with glow effect
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.auroraLavender.withOpacity(0.12),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Image.asset(
                      "assets/ai3.png",
                      height: 200,
                    ),
                  ],
                ).animate().fadeIn(duration: 700.ms).scale(
                      begin: const Offset(0.85, 0.85),
                      end: const Offset(1, 1),
                      duration: 700.ms,
                    ),

                Column(
                  children: [
                    // Hello badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
                      decoration: BoxDecoration(
                        gradient: AppGradients.cardGradient,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.auroraLavender.withOpacity(0.3),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.glowPurple,
                            blurRadius: 20,
                            spreadRadius: -4,
                          ),
                        ],
                      ),
                      child: Text(
                        "Hello 👋",
                        style: AppTypography.displayLarge,
                        textAlign: TextAlign.center,
                      ),
                    ).animate().fadeIn(delay: 400.ms, duration: 600.ms),

                    const SizedBox(height: 36),

                    // Dr. Savi introduction
                    Text(
                      "I'm Dr. SAVI",
                      textAlign: TextAlign.center,
                      style: AppTypography.displayMedium.copyWith(
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: [
                              AppColors.auroraLavender,
                              AppColors.auroraRose,
                            ],
                          ).createShader(
                              const Rect.fromLTWH(0, 0, 250, 40)),
                      ),
                    ).animate().fadeIn(delay: 600.ms, duration: 600.ms),

                    const SizedBox(height: 12),

                    Text(
                      "❤️\nA space to think, feel, and grow.",
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.moonGray,
                        height: 1.6,
                      ),
                    ).animate().fadeIn(delay: 800.ms, duration: 600.ms),
                  ],
                ),

                CustomButton(
                  text: "LET'S DO IT TOGETHER?",
                  onPressed: () async {
                    if (await Vibration.hasVibrator() ?? false) {
                      Vibration.vibrate(duration: 100);
                    }
                    Get.to(
                      () => const SelectUserIssues(),
                      curve: Curves.easeIn,
                      transition: Transition.rightToLeftWithFade,
                    );
                  },
                ).animate().fadeIn(delay: 1000.ms, duration: 500.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}