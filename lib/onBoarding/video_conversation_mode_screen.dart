import 'package:ai_therapy/onBoarding/video_conversation_page.dart';
import 'package:ai_therapy/custom_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';
import 'package:get/get.dart';

import '../app_theme.dart';
import '../Controllers/user_controller.dart';

class VideoConverstaionModeScreen extends StatelessWidget {
  const VideoConverstaionModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        otherWidget: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 1),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 300,
                      height: 300,
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
                    Image.asset("assets/robot.png", height: 250),
                  ],
                ).animate().fadeIn(duration: 700.ms),

                const SizedBox(height: 24),

                Text(
                  "Are You Ready?",
                  style: AppTypography.displayMedium,
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 300.ms, duration: 500.ms),

                const SizedBox(height: 8),
                Text(
                  "How are you feeling today?",
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.moonGray,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 450.ms, duration: 500.ms),

                const Spacer(flex: 2),

                _mainButton(
                  context,
                  "Let's start Visual Conversation",
                  null,
                  AppColors.auroraLavender,
                ).animate().fadeIn(delay: 600.ms, duration: 500.ms),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _mainButton(
      BuildContext context, String text, IconData? icon, Color color) {
    if (icon == null) {
      Get.find<UserController>().selectedConvMode.value = 1;
    } else {
      Get.find<UserController>().selectedConvMode.value = 0;
    }
    return GestureDetector(
      onTap: () async {
        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate(duration: 100);
        }

        Get.to(
          () => const VideoConversationPage(),
          curve: Curves.easeIn,
          transition: Transition.downToUp,
        );
      },
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon == null
                  ? Image.asset(
                      "assets/voice_chat.png",
                      width: 28,
                      height: 28,
                      color: color,
                    )
                  : Icon(icon, size: 26, color: color),
              const SizedBox(width: 12),
              Text(
                text,
                style: AppTypography.labelLarge.copyWith(
                  color: color,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
