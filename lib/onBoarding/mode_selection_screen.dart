import 'dart:ui';
import 'package:ai_therapy/onBoarding/saved_summary_screen.dart';
import 'package:ai_therapy/onBoarding/therapist_list_page.dart';
import 'package:ai_therapy/onBoarding/video_conversation_mode_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../app_theme.dart';
import '../custom_background.dart';
import 'chat_history_page.dart';
import 'chat_mode_screen.dart';
import 'audio_conversation_mode_screen.dart';

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        otherWidget: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  "Choose Your Mode",
                  textAlign: TextAlign.center,
                  style: AppTypography.displayMedium,
                ).animate().fadeIn(duration: 500.ms),

                const SizedBox(height: 8),
                Text(
                  "Select how you want to interact",
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium,
                ).animate().fadeIn(delay: 200.ms, duration: 500.ms),

                const SizedBox(height: 32),

                // 2x2 Grid of mode cards
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.9,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _ModeCard(
                        icon: Icons.chat_bubble_rounded,
                        title: "Chat",
                        subtitle: "Text conversation",
                        accentColor: AppColors.auroraTeal,
                        delay: 300,
                        onTap: () => Get.to(() => const ChatModeScreen()),
                      ),
                      _ModeCard(
                        icon: Icons.mic_rounded,
                        title: "Voice",
                        subtitle: "Audio conversation",
                        accentColor: AppColors.auroraRose,
                        delay: 400,
                        onTap: () => Get.to(() => const AudioConverstaionModeScreen()),
                      ),
                      _ModeCard(
                        icon: Icons.videocam_rounded,
                        title: "Visual",
                        subtitle: "Face-to-face AI",
                        accentColor: AppColors.auroraLavender,
                        delay: 500,
                        onTap: () => Get.to(() => const VideoConverstaionModeScreen()),
                      ),
                      _ModeCard(
                        icon: Icons.medical_services_rounded,
                        title: "Therapist",
                        subtitle: "Consult a professional",
                        accentColor: AppColors.auroraGold,
                        delay: 600,
                        onTap: () => Get.to(() => const TherapistListPage()),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Bottom actions
                Row(
                  children: [
                    Expanded(
                      child: _BottomActionButton(
                        icon: Icons.history_rounded,
                        label: "History",
                        onTap: () => Get.to(() => ChatHistoryPage()),
                      ).animate().fadeIn(delay: 700.ms, duration: 500.ms),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _BottomActionButton(
                        icon: Icons.bookmark_rounded,
                        label: "Saved Summaries",
                        onTap: () => Get.to(() => SavedSummariesScreen()),
                      ).animate().fadeIn(delay: 800.ms, duration: 500.ms),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final int delay;
  final VoidCallback onTap;

  const _ModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: GlassDecoration.accentCard(
              glowColor: accentColor,
              borderRadius: 22,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: accentColor, size: 28),
                ),
                const SizedBox(height: 14),
                Text(
                  title,
                  style: AppTypography.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay), duration: 500.ms)
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
  }
}

class _BottomActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BottomActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.glassWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.auroraLavender, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
