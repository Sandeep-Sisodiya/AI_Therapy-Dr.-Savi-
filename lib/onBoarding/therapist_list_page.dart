import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../Models/therapist_model.dart';
import '../app_theme.dart';
import '../custom_background.dart';
import 'therapist_detail_page.dart';

class TherapistListPage extends StatelessWidget {
  const TherapistListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<TherapistModel>('therapists');

    return Scaffold(
      body: CustomBackground(
        otherWidget: SafeArea(
          child: Column(
            children: [
              // Custom styled AppBar Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppColors.starWhite, size: 20),
                      onPressed: () => Get.back(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Therapists",
                      style: AppTypography.displaySmall,
                    ),
                  ],
                ),
              ),

              // Therapist List
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: box.listenable(),
                  builder: (context, Box<TherapistModel> box, _) {
                    if (box.values.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline_rounded,
                              size: 64,
                              color: AppColors.moonGray.withOpacity(0.4),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No Therapist Profiles Available",
                              style: AppTypography.headlineMedium.copyWith(
                                color: AppColors.moonGray,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Profiles registered in Hive will appear here",
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: box.length,
                      itemBuilder: (context, index) {
                        final therapist = box.getAt(index)!;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: GlassDecoration.accentCard(
                                  glowColor: AppColors.auroraTeal,
                                  borderRadius: 20,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Doctor Photo with glow ring
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.auroraTeal.withOpacity(0.5),
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.auroraTeal.withOpacity(0.2),
                                            blurRadius: 10,
                                            spreadRadius: -2,
                                          )
                                        ],
                                      ),
                                      child: CircleAvatar(
                                        radius: 40,
                                        backgroundColor: AppColors.cosmicIndigo,
                                        backgroundImage: therapist.doctorIdPath.isNotEmpty
                                            ? FileImage(File(therapist.doctorIdPath))
                                            : null,
                                        child: therapist.doctorIdPath.isEmpty
                                            ? const Icon(Icons.person_rounded,
                                                color: AppColors.auroraTeal, size: 30)
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(width: 18),
                                    // Limited info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            therapist.name,
                                            style: AppTypography.headlineLarge.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.starWhite,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            therapist.specialization,
                                            style: AppTypography.bodyMedium.copyWith(
                                              color: AppColors.auroraTeal,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              const Icon(Icons.location_on_outlined,
                                                  color: AppColors.moonGray, size: 14),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  therapist.clinic,
                                                  style: AppTypography.bodySmall.copyWith(
                                                    color: AppColors.moonGray,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 14),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColors.auroraTeal,
                                                foregroundColor: Colors.black,
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 16, vertical: 8),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              onPressed: () {
                                                Get.to(
                                                  () => TherapistDetailPage(therapist: therapist),
                                                  transition: Transition.rightToLeftWithFade,
                                                );
                                              },
                                              child: Text(
                                                "View Details",
                                                style: AppTypography.labelSmall.copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ).animate().fadeIn(
                              delay: (100 * index).ms,
                              duration: 400.ms,
                            );
                      },
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
