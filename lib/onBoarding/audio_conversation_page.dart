import 'package:ai_therapy/Controllers/chat_controller.dart';
import 'package:ai_therapy/Controllers/user_controller.dart';
import 'package:ai_therapy/custom_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../app_theme.dart';
import 'customize_attributes_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late ChatController chatController;
  late AnimationController _animController;
  late UserController userController;

  @override
  void initState() {
    userController = Get.put(UserController());

    chatController = Get.put(ChatController());
    _animController = AnimationController(
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        otherWidget: Obx(
          () => chatController.loading.value
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          color: AppColors.auroraLavender,
                          strokeWidth: 3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text("Getting ready..",
                          style: AppTypography.bodyMedium),
                    ],
                  ),
                )
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/robot.png",
                              height: 100,
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => const CustomizeAttributesScreen(
                                    saveDetails: true,
                                  ),
                                  transition: Transition.rightToLeft,
                                );
                              },
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.glassWhite,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                      color: AppColors.glassBorder, width: 1),
                                ),
                                child: const Icon(
                                  Icons.settings_rounded,
                                  color: AppColors.auroraLavender,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Obx(() => chatController.isListening.value
                            ? chatController.isListeningDone.value
                                ? Animate(
                                    child: Lottie.asset(
                                    'assets/speaking.json',
                                    height: 200,
                                    controller: _animController,
                                    onLoaded: (composition) {
                                      _animController.duration =
                                          composition.duration;
                                      _animController.repeat();
                                    },
                                  )).fadeIn()
                                : Animate(
                                    child: Lottie.asset(
                                      'assets/listening.json',
                                      height: 200,
                                      controller: _animController,
                                      onLoaded: (composition) {
                                        _animController.duration =
                                            composition.duration;
                                        _animController.forward();
                                      },
                                    ),
                                  ).fadeIn()
                            : _buildMicButton()),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (chatController.isListeningDone.value)
              _buildControlButton(
                icon: CupertinoIcons.pause,
                color: AppColors.cosmicIndigo,
                onPressed: () => chatController.stopListening(),
              ),
            chatController.isListeningDone.value
                ? const SizedBox()
                : Text(
                    chatController.isListening.value
                        ? "Listening.."
                        : "Start Speaking by pressing\nthe above button",
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.moonGray.withOpacity(0.5),
                    ),
                  ),
            if (chatController.isListeningDone.value)
              _buildControlButton(
                icon: CupertinoIcons.xmark,
                color: AppColors.errorRed,
                onPressed: () => chatController.stopListening(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMicButton() {
    return GestureDetector(
      onTap: () => chatController.startListening(),
      child: Container(
        height: 160,
        width: 160,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.glassWhite,
          border: Border.all(
            color: AppColors.auroraLavender.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.auroraLavender.withOpacity(0.2),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: const Icon(
          Icons.mic_rounded,
          size: 60,
          color: AppColors.auroraLavender,
        ),
      ),
    ).animate().fadeIn().scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          duration: 600.ms,
        );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: color.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}