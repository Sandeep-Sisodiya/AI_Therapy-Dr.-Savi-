import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_theme.dart';
import '../custom_background.dart';

class SummaryScreen extends StatefulWidget {
  final Map<String, dynamic> summaryData;

  const SummaryScreen({Key? key, required this.summaryData}) : super(key: key);

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final box = GetStorage();
  List<bool> dayDoneStatus = [];
  bool isAlreadySaved = false;

  // Only 3-4 feel-good movies/shows (Bollywood + Hollywood)
  final List<Map<String, String>> movieSuggestions = [
    {
      "title": "Zindagi Na Milegi Dobara",
      "year": "2011",
      "genre": "Bollywood, Drama, Adventure",
      "description":
          "A soulful journey of three friends discovering life, love, and themselves while traveling across Spain. Packed with humor, emotions, and breathtaking visuals, it's a modern Bollywood classic about friendship and living in the moment."
    },
    {
      "title": "The Pursuit of Happyness",
      "year": "2006",
      "genre": "Drama, Biography",
      "description":
          "A deeply moving film starring Will Smith about a struggling salesman who never gives up on his dreams. A powerful reminder of hope, resilience, and the importance of family."
    },
    {
      "title": "Yeh Jawaani Hai Deewani",
      "year": "2013",
      "genre": "Bollywood, Romance, Drama",
      "description":
          "A vibrant Bollywood film exploring friendship, love, and chasing dreams. With foot-tapping music, heartwarming moments, and relatable characters, it leaves you with a smile and a sense of nostalgia."
    },
    {
      "title": "The Intern",
      "year": "2015",
      "genre": "Comedy, Drama",
      "description":
          "A delightful movie about a 70-year-old widower who becomes an intern at a fashion startup. Heartwarming, funny, and inspiring — it shows that life has no age limits for new beginnings."
    },
  ];

  @override
  void initState() {
    super.initState();
    final daywise = List<String>.from(widget.summaryData['daywise'] ?? []);
    dayDoneStatus = List.generate(daywise.length, (_) => false);

    List stored = box.read('savedSummaries') ?? [];
    final existingIndex = stored.indexWhere((s) =>
        s['summary'] == widget.summaryData['summary'] &&
        s['daywise'].toString() ==
            widget.summaryData['daywise'].toString());

    if (existingIndex != -1) {
      isAlreadySaved = true;
      final savedSummary = stored[existingIndex];
      if (savedSummary['dayDoneStatus'] != null) {
        dayDoneStatus = List<bool>.from(savedSummary['dayDoneStatus']);
      }
    }
  }

  void saveSummary() {
    List stored = box.read('savedSummaries') ?? [];
    widget.summaryData['dayDoneStatus'] = dayDoneStatus;

    if (isAlreadySaved) {
      final existingIndex = stored.indexWhere((s) =>
          s['summary'] == widget.summaryData['summary'] &&
          s['daywise'].toString() ==
              widget.summaryData['daywise'].toString());
      if (existingIndex != -1) {
        stored[existingIndex] = widget.summaryData;
      }
    } else {
      stored.add(widget.summaryData);
      isAlreadySaved = true;
    }

    box.write('savedSummaries', stored);
    Get.snackbar(
      "Success",
      "Summary saved successfully!",
      backgroundColor: AppColors.cosmicIndigo.withOpacity(0.8),
      colorText: AppColors.starWhite,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      borderWidth: 1,
      borderColor: AppColors.glassBorder,
    );
    setState(() {});
  }

  void markDayDone(int index) {
    setState(() {
      dayDoneStatus[index] = true;
    });
    // Auto-update if it is already in saved list
    List stored = box.read('savedSummaries') ?? [];
    final existingIndex = stored.indexWhere((s) =>
        s['summary'] == widget.summaryData['summary'] &&
        s['daywise'].toString() ==
            widget.summaryData['daywise'].toString());
    if (existingIndex != -1) {
      stored[existingIndex]['dayDoneStatus'] = dayDoneStatus;
      box.write('savedSummaries', stored);
    }
  }

  @override
  Widget build(BuildContext context) {
    final summary = widget.summaryData['summary'] ?? "";
    final daywise = List<String>.from(widget.summaryData['daywise'] ?? []);

    return Scaffold(
      body: CustomBackground(
        otherWidget: SafeArea(
          child: Column(
            children: [
              // Custom AppBar
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
                          "Summary & Targets",
                          style: AppTypography.displaySmall,
                        ),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isAlreadySaved
                                ? AppColors.auroraTeal.withOpacity(0.15)
                                : AppColors.glassWhite,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isAlreadySaved
                                  ? AppColors.auroraTeal.withOpacity(0.3)
                                  : AppColors.glassBorder,
                              width: 1,
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(
                              isAlreadySaved
                                  ? Icons.bookmark_added_rounded
                                  : Icons.bookmark_add_outlined,
                              color: isAlreadySaved
                                  ? AppColors.auroraTeal
                                  : AppColors.starWhite,
                              size: 22,
                            ),
                            onPressed: saveSummary,
                            tooltip: "Save Summary",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Summary Card
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: GlassDecoration.accentCard(
                              glowColor: AppColors.auroraLavender,
                              borderRadius: 24,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.auroraLavender.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.auto_awesome_rounded,
                                        color: AppColors.auroraLavender,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      "Dr. Savi's Insights",
                                      style: AppTypography.headlineLarge,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  summary,
                                  style: AppTypography.bodyLarge.copyWith(
                                    height: 1.6,
                                    color: AppColors.starWhite.withOpacity(0.95),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.05, end: 0),

                      const SizedBox(height: 32),

                      // Day-wise Plan section header
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            color: AppColors.auroraRose,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "7-Day Action Plan",
                            style: AppTypography.headlineLarge,
                          ),
                        ],
                      ).animate().fadeIn(delay: 200.ms),

                      const SizedBox(height: 16),

                      // Day Cards List
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: daywise.length,
                        itemBuilder: (context, index) {
                          final isDone = dayDoneStatus[index];
                          return AnimatedOpacity(
                            duration: const Duration(milliseconds: 400),
                            opacity: isDone ? 0.6 : 1.0,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 16),
                                    decoration: BoxDecoration(
                                      gradient: isDone
                                          ? LinearGradient(
                                              colors: [
                                                AppColors.auroraTeal.withOpacity(0.08),
                                                AppColors.auroraTeal.withOpacity(0.02),
                                              ],
                                            )
                                          : AppGradients.cardGradient,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isDone
                                            ? AppColors.auroraTeal.withOpacity(0.3)
                                            : AppColors.glassBorder,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        // Day Badge
                                        Container(
                                          width: 44,
                                          height: 44,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: isDone
                                                ? AppColors.auroraTeal.withOpacity(0.15)
                                                : AppColors.cosmicIndigo,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isDone
                                                  ? AppColors.auroraTeal.withOpacity(0.4)
                                                  : AppColors.auroraRose.withOpacity(0.3),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Text(
                                            "${index + 1}",
                                            style: AppTypography.headlineMedium.copyWith(
                                              color: isDone
                                                  ? AppColors.auroraTeal
                                                  : AppColors.auroraRose,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        // Day Description
                                        Expanded(
                                          child: Text(
                                            daywise[index],
                                            style: AppTypography.bodyMedium.copyWith(
                                              color: AppColors.starWhite,
                                              decoration: isDone
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        // Action Button
                                        if (!isDone)
                                          TextButton(
                                            onPressed: () => markDayDone(index),
                                            style: TextButton.styleFrom(
                                              foregroundColor: AppColors.auroraTeal,
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 8),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                side: BorderSide(
                                                  color: AppColors.auroraTeal.withOpacity(0.4),
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              "Done",
                                              style: AppTypography.labelSmall.copyWith(
                                                color: AppColors.auroraTeal,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        else
                                          const Icon(
                                            Icons.check_circle_rounded,
                                            color: AppColors.auroraTeal,
                                            size: 24,
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

                      const SizedBox(height: 32),

                      // Recommendations Header
                      Row(
                        children: [
                          const Icon(
                            Icons.movie_creation_outlined,
                            color: AppColors.auroraTeal,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Mindful Content",
                                style: AppTypography.headlineLarge,
                              ),
                              Text(
                                "Curated media to lift your spirits",
                                style: AppTypography.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ).animate().fadeIn(delay: 400.ms),

                      const SizedBox(height: 16),

                      // Movie Carousel (PageView.builder)
                      SizedBox(
                        height: 240,
                        child: PageView.builder(
                          controller: PageController(viewportFraction: 0.85),
                          itemCount: movieSuggestions.length,
                          itemBuilder: (context, index) {
                            final movie = movieSuggestions[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: GlassDecoration.card(borderRadius: 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                movie['title'] ?? "",
                                                style: AppTypography.headlineMedium.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              movie['year'] ?? "",
                                              style: AppTypography.bodySmall.copyWith(
                                                color: AppColors.auroraTeal,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        // Genre Chip style
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.auroraTeal.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            movie['genre'] ?? "",
                                            style: AppTypography.bodySmall.copyWith(
                                              color: AppColors.auroraTeal,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Expanded(
                                          child: Text(
                                            movie['description'] ?? "",
                                            style: AppTypography.bodyMedium.copyWith(
                                              color: AppColors.starWhite.withOpacity(0.8),
                                              height: 1.4,
                                            ),
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ).animate().fadeIn(delay: 500.ms),

                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
