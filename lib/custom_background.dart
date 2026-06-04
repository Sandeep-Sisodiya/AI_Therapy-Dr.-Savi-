import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_theme.dart';

class CustomBackground extends StatelessWidget {
  final Widget otherWidget;
  final bool maximizeHeight;
  const CustomBackground(
      {super.key, required this.otherWidget, this.maximizeHeight = true});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Base gradient background
        Container(
          height: maximizeHeight ? Get.height : 320,
          decoration: const BoxDecoration(
            gradient: AppGradients.backgroundGradient,
          ),
        ),
        // Ambient glow orbs for depth
        Positioned(
          top: -80,
          right: -60,
          child: Container(
            width: 260,
            height: 260,
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
        Positioned(
          bottom: -100,
          left: -80,
          child: Container(
            width: 300,
            height: 300,
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
        Positioned(
          top: Get.height * 0.4,
          left: Get.width * 0.5 - 100,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.auroraTeal.withOpacity(0.04),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Content
        otherWidget,
      ],
    );
  }
}