import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Models/therapist_model.dart';
import '../app_theme.dart';
import '../custom_background.dart';

class TherapistDetailPage extends StatelessWidget {
  final TherapistModel therapist;
  const TherapistDetailPage({super.key, required this.therapist});

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
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppColors.starWhite, size: 20),
                      onPressed: () => Get.back(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Therapist Profile",
                      style: AppTypography.displaySmall,
                    ),
                  ],
                ),
              ),

              // Detail content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Doctor Photo & Header Info
                      Center(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () => _showImageDialog(context, therapist.doctorIdPath),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.auroraTeal.withOpacity(0.6),
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.auroraTeal.withOpacity(0.3),
                                      blurRadius: 20,
                                      spreadRadius: -2,
                                    )
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 56,
                                  backgroundColor: AppColors.cosmicIndigo,
                                  backgroundImage: therapist.doctorIdPath.isNotEmpty
                                      ? FileImage(File(therapist.doctorIdPath))
                                      : null,
                                  child: therapist.doctorIdPath.isEmpty
                                      ? const Icon(Icons.person_rounded,
                                          color: AppColors.auroraTeal, size: 40)
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              therapist.name,
                              style: AppTypography.displayMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.auroraTeal.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.auroraTeal.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                therapist.specialization,
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.auroraTeal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 500.ms),

                      const SizedBox(height: 32),

                      // Bio Card
                      _buildCard(
                        title: "Biography",
                        icon: Icons.description_outlined,
                        child: Text(
                          therapist.bio,
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.starWhite.withOpacity(0.95),
                            height: 1.6,
                          ),
                        ),
                      ).animate().fadeIn(delay: 100.ms),

                      const SizedBox(height: 20),

                      // Info List Card
                      _buildCard(
                        title: "General Information",
                        icon: Icons.info_outline_rounded,
                        child: Column(
                          children: [
                            _buildDetailRow("Gender", therapist.gender, Icons.wc_rounded),
                            _buildDetailRow("Phone", therapist.phone, Icons.phone_outlined),
                            if (therapist.altPhone.isNotEmpty)
                              _buildDetailRow("Alt Phone", therapist.altPhone, Icons.phone_android_outlined),
                            _buildDetailRow("Email", therapist.email, Icons.email_outlined),
                            _buildDetailRow("Clinic/Hospital", therapist.clinic, Icons.location_on_outlined),
                            _buildDetailRow("Degrees", therapist.degrees, Icons.school_outlined),
                            _buildDetailRow("Experience", "${therapist.experience} Years", Icons.work_history_outlined),
                            _buildDetailRow("Consultation Fees", therapist.fees, Icons.attach_money_outlined),
                          ],
                        ),
                      ).animate().fadeIn(delay: 200.ms),

                      const SizedBox(height: 20),

                      // Documents Card
                      if (therapist.documentPaths.isNotEmpty)
                        _buildCard(
                          title: "Verification Documents",
                          icon: Icons.verified_user_outlined,
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1,
                            ),
                            itemCount: therapist.documentPaths.length,
                            itemBuilder: (context, index) {
                              final path = therapist.documentPaths[index];
                              return GestureDetector(
                                onTap: () => _showImageDialog(context, path),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.glassBorder),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      File(path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ).animate().fadeIn(delay: 300.ms),

                      const SizedBox(height: 40),
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

  // Generic Card with title
  Widget _buildCard({required String title, required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
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
                  children: [
                    Icon(icon, color: AppColors.auroraTeal, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      title,
                      style: AppTypography.headlineLarge.copyWith(
                        color: AppColors.auroraTeal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Detail row for info card
  Widget _buildDetailRow(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.moonGray.withOpacity(0.7), size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$title: ",
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.moonGray,
                  ),
                ),
                Expanded(
                  child: Text(
                    value,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.starWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Show image in full-screen with blurred backdrop
  void _showImageDialog(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(12),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 3.0,
              child: Image.file(
                File(imagePath),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
