import 'package:ai_therapy/Widgets/custom_button.dart';
import 'package:ai_therapy/Widgets/custom_slider.dart';
import 'package:ai_therapy/custom_background.dart';
import 'package:ai_therapy/onBoarding/audio_conversation_mode_screen.dart';
import 'package:ai_therapy/onBoarding/mode_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../app_theme.dart';
import '../Controllers/user_controller.dart';

class CustomizeAttributesScreen extends StatelessWidget {
  final bool saveDetails;
  const CustomizeAttributesScreen({super.key, required this.saveDetails});

  @override
  Widget build(BuildContext context) {
    final userController =
        Get.find<UserController>() ?? Get.put(UserController());
    return Scaffold(
      body: CustomBackground(
        otherWidget: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "Customize Your AI",
                      textAlign: TextAlign.center,
                      style: AppTypography.displayMedium,
                    ).animate().fadeIn(duration: 500.ms),

                    const SizedBox(height: 12),

                    Text(
                      "Design how Dr. Savi responds to you",
                      style: AppTypography.bodyMedium,
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
                  ],
                ),
                Column(
                  children: [
                    Obx(
                      () => CustomSlider(
                        leadingText: "Empathy",
                        trailingText: "Understanding",
                        defaultValue: userController.empUnd.value.toDouble(),
                        onChanged: (value) {
                          userController.empUnd.value = value.round();
                        },
                      ),
                    ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
                    Obx(
                      () => CustomSlider(
                        leadingText: "Listening",
                        trailingText: "Solutioning",
                        defaultValue: userController.lisSol.value.toDouble(),
                        onChanged: (value) {
                          userController.lisSol.value = value.round();
                        },
                      ),
                    ).animate().fadeIn(delay: 450.ms, duration: 500.ms),
                    Obx(
                      () => CustomSlider(
                        leadingText: "Holistic",
                        trailingText: "Targeted",
                        defaultValue: userController.hoTa.value.toDouble(),
                        onChanged: (value) {
                          userController.hoTa.value = value.round();
                        },
                      ),
                    ).animate().fadeIn(delay: 600.ms, duration: 500.ms),
                  ],
                ),
                CustomButton(
                  text: saveDetails ? "Save" : "Continue",
                  onPressed: () {
                    if (saveDetails) {
                      Get.back();
                    } else {
                      Get.to(() => const ModeSelectionScreen());
                    }
                  },
                ).animate().fadeIn(delay: 750.ms, duration: 500.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}