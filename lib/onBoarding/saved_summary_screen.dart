import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_theme.dart';
import '../custom_background.dart';
import 'summary_screen.dart';

class SavedSummariesScreen extends StatefulWidget {
  const SavedSummariesScreen({Key? key}) : super(key: key);

  @override
  State<SavedSummariesScreen> createState() => _SavedSummariesScreenState();
}

class _SavedSummariesScreenState extends State<SavedSummariesScreen> {
  final box = GetStorage();
  List<Map<String, dynamic>> savedSummaries = [];

  @override
  void initState() {
    super.initState();
    loadSummaries();
  }

  void loadSummaries() {
    List stored = box.read('savedSummaries') ?? [];
    savedSummaries = stored
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    setState(() {});
  }

  void markTargetAchieved(int index) {
    setState(() {
      savedSummaries[index]['achieved'] = true;
      box.write('savedSummaries', savedSummaries);
    });
    Get.snackbar(
      "Congratulations!",
      "You have achieved your target! Keep it up.",
      backgroundColor: AppColors.auroraTeal.withOpacity(0.2),
      colorText: AppColors.starWhite,
      borderColor: AppColors.auroraTeal.withOpacity(0.4),
      borderWidth: 1,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
    );
  }

  void deleteSummary(int index) {
    setState(() {
      savedSummaries.removeAt(index);
      box.write('savedSummaries', savedSummaries);
    });
    Get.snackbar(
      "Deleted",
      "Summary removed successfully.",
      backgroundColor: AppColors.cosmicIndigo.withOpacity(0.8),
      colorText: AppColors.starWhite,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
    );
  }

  void showOptionsDialog(int index) {
    Get.defaultDialog(
      title: "Remove Summary",
      titleStyle: AppTypography.headlineLarge.copyWith(color: AppColors.starWhite),
      middleText: "Are you sure you want to delete this summary?",
      middleTextStyle: AppTypography.bodyMedium,
      backgroundColor: AppColors.midnightBlue,
      radius: 16,
      contentPadding: const EdgeInsets.all(20),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            "Cancel",
            style: AppTypography.labelMedium.copyWith(color: AppColors.moonGray),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.errorRed,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          onPressed: () {
            deleteSummary(index);
            Get.back();
          },
          child: Text(
            "Delete",
            style: AppTypography.labelMedium.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        otherWidget: SafeArea(
          child: Column(
            children: [
              // Custom styled AppBar Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: AppColors.starWhite, size: 20),
                          onPressed: () => Get.back(),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Saved Plans",
                          style: AppTypography.displaySmall,
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded, color: AppColors.starWhite),
                      tooltip: "Reload",
                      onPressed: loadSummaries,
                    ),
                  ],
                ),
              ),

              // Saved Summaries List
              Expanded(
                child: savedSummaries.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bookmark_outline_rounded,
                              size: 64,
                              color: AppColors.moonGray.withOpacity(0.4),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No saved plans yet",
                              style: AppTypography.headlineMedium.copyWith(
                                color: AppColors.moonGray,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Save a conversation summary to view it here",
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: savedSummaries.length,
                        itemBuilder: (context, index) {
                          final summary = savedSummaries[index];
                          final achieved = summary['achieved'] ?? false;

                          return GestureDetector(
                            onLongPress: () => showOptionsDialog(index),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    padding: const EdgeInsets.all(18),
                                    decoration: achieved
                                        ? GlassDecoration.accentCard(
                                            glowColor: AppColors.auroraTeal,
                                            borderRadius: 20,
                                          )
                                        : GlassDecoration.card(borderRadius: 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Icon / Badge status
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: achieved
                                                    ? AppColors.auroraTeal.withOpacity(0.15)
                                                    : AppColors.auroraLavender.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Icon(
                                                achieved
                                                    ? Icons.emoji_events_rounded
                                                    : Icons.auto_awesome_rounded,
                                                color: achieved
                                                    ? AppColors.auroraTeal
                                                    : AppColors.auroraLavender,
                                                size: 20,
                                              ),
                                            ),
                                            const SizedBox(width: 14),
                                            // Summary title
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    summary['summary'] ?? '',
                                                    style: AppTypography.bodyLarge.copyWith(
                                                      fontWeight: FontWeight.w600,
                                                      color: AppColors.starWhite,
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    (summary['daywise'] as List<dynamic>?)
                                                            ?.join(" • ") ??
                                                        '',
                                                    style: AppTypography.bodySmall.copyWith(
                                                      color: AppColors.moonGray,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        // Bottom actions inside card
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Get.to(() => SummaryScreen(summaryData: summary));
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "View Plan",
                                                    style: AppTypography.labelSmall.copyWith(
                                                      color: AppColors.auroraLavender,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  const Icon(
                                                    Icons.arrow_forward_rounded,
                                                    size: 14,
                                                    color: AppColors.auroraLavender,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (achieved)
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 12, vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: AppColors.auroraTeal.withOpacity(0.15),
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: AppColors.auroraTeal.withOpacity(0.3),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.check_circle_outline_rounded,
                                                      color: AppColors.auroraTeal,
                                                      size: 14,
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Text(
                                                      "Achieved",
                                                      style: AppTypography.labelSmall.copyWith(
                                                        color: AppColors.auroraTeal,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            else
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: AppColors.auroraTeal,
                                                  foregroundColor: Colors.black,
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 16, vertical: 8),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                ),
                                                onPressed: () => markTargetAchieved(index),
                                                child: Text(
                                                  "Complete Target",
                                                  style: AppTypography.labelSmall.copyWith(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ).animate().fadeIn(
                                delay: (100 * index).ms,
                                duration: 400.ms,
                              );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
