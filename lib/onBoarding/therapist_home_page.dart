import 'dart:io';
import 'dart:ui';
import 'package:ai_therapy/onBoarding/therapist_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

import '../Models/therapist_model.dart';
import '../Widgets/custom_button.dart';
import '../app_theme.dart';
import '../custom_background.dart';
import 'user_therapist_choice_page.dart';

class TherapistProfilePage extends StatefulWidget {
  const TherapistProfilePage({super.key});

  @override
  State<TherapistProfilePage> createState() => _TherapistProfilePageState();
}

class _TherapistProfilePageState extends State<TherapistProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController altPhoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController clinicController = TextEditingController();
  final TextEditingController degreesController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController specializationController = TextEditingController();
  final TextEditingController feesController = TextEditingController();

  String gender = 'Select Gender';
  final ImagePicker _picker = ImagePicker();

  List<File> documentFiles = [];
  File? doctorIdFile;

  // Choose image from gallery or camera
  Future<void> _chooseImage(Function(File) onPicked) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.midnightBlue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  "Choose Image Source",
                  style: AppTypography.headlineMedium,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded, color: AppColors.auroraTeal),
              title: Text("Gallery", style: AppTypography.bodyLarge),
              onTap: () async {
                Navigator.pop(context);
                try {
                  final XFile? file =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (file != null) onPicked(File(file.path));
                } catch (e) {
                  Get.snackbar(
                    "Error",
                    "Failed to pick image: $e",
                    backgroundColor: AppColors.errorRed.withOpacity(0.2),
                    colorText: AppColors.starWhite,
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded, color: AppColors.auroraTeal),
              title: Text("Camera", style: AppTypography.bodyLarge),
              onTap: () async {
                Navigator.pop(context);
                try {
                  final XFile? file =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (file != null) onPicked(File(file.path));
                } catch (e) {
                  Get.snackbar(
                    "Error",
                    "Failed to capture image: $e",
                    backgroundColor: AppColors.errorRed.withOpacity(0.2),
                    colorText: AppColors.starWhite,
                  );
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        otherWidget: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Image.asset("assets/ai3.png", height: 110)
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .scale(begin: const Offset(0.9, 0.9)),
                const SizedBox(height: 12),
                Text(
                  "Therapist Profile",
                  style: AppTypography.displayMedium,
                ),
                Text(
                  "Set up your profile to connect with patients",
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(height: 24),

                // Group 1: Personal Info Card
                _buildSectionHeader("Personal Details", Icons.person_outline_rounded),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: GlassDecoration.card(borderRadius: 20),
                      child: Column(
                        children: [
                          _buildTextField("Full Name *", nameController, Icons.badge_outlined),
                          const SizedBox(height: 14),
                          // Gender Selector
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: AppColors.midnightBlue,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                builder: (_) => SafeArea(
                                  child: Wrap(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        child: Center(
                                          child: Text("Select Gender", style: AppTypography.headlineMedium),
                                        ),
                                      ),
                                      const Divider(),
                                      ...['Male', 'Female', 'Other']
                                          .map((g) => ListTile(
                                                title: Text(g, style: AppTypography.bodyLarge),
                                                onTap: () {
                                                  setState(() {
                                                    gender = g;
                                                  });
                                                  Navigator.pop(context);
                                                },
                                              ))
                                          .toList(),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              decoration: GlassDecoration.inputField(borderRadius: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.wc_rounded, color: AppColors.auroraTeal, size: 20),
                                      const SizedBox(width: 12),
                                      Text(
                                        gender == 'Select Gender' ? "Gender *" : gender,
                                        style: gender == 'Select Gender'
                                            ? AppTypography.bodyMedium.copyWith(
                                                color: AppColors.moonGray.withOpacity(0.6),
                                              )
                                            : AppTypography.bodyLarge,
                                      ),
                                    ],
                                  ),
                                  const Icon(Icons.arrow_drop_down_rounded, color: AppColors.moonGray),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          _buildTextField("Phone Number *", phoneController, Icons.phone_outlined, keyboardType: TextInputType.phone),
                          const SizedBox(height: 14),
                          _buildTextField("Alternate Phone (Optional)", altPhoneController, Icons.phone_android_outlined, keyboardType: TextInputType.phone),
                          const SizedBox(height: 14),
                          _buildTextField("Email ID *", emailController, Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                        ],
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 100.ms),

                const SizedBox(height: 24),

                // Group 2: Professional Details
                _buildSectionHeader("Professional Details", Icons.school_outlined),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: GlassDecoration.card(borderRadius: 20),
                      child: Column(
                        children: [
                          _buildTextField("Degrees * (e.g. MD, PhD)", degreesController, Icons.school_outlined),
                          const SizedBox(height: 14),
                          _buildTextField("Specialization * (e.g. Anxiety, Trauma)", specializationController, Icons.health_and_safety_outlined),
                          const SizedBox(height: 14),
                          _buildTextField("Years of Experience *", experienceController, Icons.work_history_outlined, keyboardType: TextInputType.number),
                          const SizedBox(height: 14),
                          _buildTextField("Consultation Fees * (USD or INR)", feesController, Icons.attach_money_outlined, keyboardType: TextInputType.number),
                          const SizedBox(height: 14),
                          _buildTextField("Clinic/Hospital Address *", clinicController, Icons.location_on_outlined, maxLines: 2),
                        ],
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 200.ms),

                const SizedBox(height: 24),

                // Group 3: Bio
                _buildSectionHeader("Short Biography", Icons.info_outline_rounded),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: GlassDecoration.card(borderRadius: 20),
                      child: _buildTextField("Tell patients about your approach and style *", bioController, Icons.description_outlined, maxLines: 4),
                    ),
                  ),
                ).animate().fadeIn(delay: 300.ms),

                const SizedBox(height: 24),

                // Group 4: Credentials upload
                _buildSectionHeader("Credentials & Verification", Icons.verified_user_outlined),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: GlassDecoration.card(borderRadius: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Document Upload
                          Text("Doctor ID Card (Required) *", style: AppTypography.headlineMedium),
                          const SizedBox(height: 10),
                          doctorIdFile != null
                              ? Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(doctorIdFile!, width: double.infinity, height: 140, fit: BoxFit.cover),
                                    ),
                                    Positioned(
                                      right: 8,
                                      top: 8,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            doctorIdFile = null;
                                          });
                                        },
                                        child: const CircleAvatar(
                                          radius: 14,
                                          backgroundColor: AppColors.errorRed,
                                          child: Icon(Icons.close_rounded, size: 18, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : GestureDetector(
                                  onTap: () => _chooseImage((file) => setState(() => doctorIdFile = file)),
                                  child: Container(
                                    width: double.infinity,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: AppColors.glassWhite,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: AppColors.glassBorder, style: BorderStyle.solid),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.add_photo_alternate_outlined, color: AppColors.auroraTeal, size: 28),
                                        const SizedBox(height: 6),
                                        Text("Upload ID Card", style: AppTypography.bodySmall),
                                      ],
                                    ),
                                  ),
                                ),

                          const SizedBox(height: 24),

                          // Proofs Upload
                          Text("Other Proofs/Certificates (Required) *", style: AppTypography.headlineMedium),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              ...documentFiles
                                  .map((file) => Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Image.file(file, width: 76, height: 76, fit: BoxFit.cover),
                                          ),
                                          Positioned(
                                            right: 2,
                                            top: 2,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  documentFiles.remove(file);
                                                });
                                              },
                                              child: const CircleAvatar(
                                                radius: 10,
                                                backgroundColor: AppColors.errorRed,
                                                child: Icon(Icons.close_rounded, size: 12, color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ))
                                  .toList(),
                              GestureDetector(
                                onTap: () => _chooseImage((file) => setState(() => documentFiles.add(file))),
                                child: Container(
                                  width: 76,
                                  height: 76,
                                  decoration: BoxDecoration(
                                    color: AppColors.glassWhite,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.glassBorder),
                                  ),
                                  child: const Icon(Icons.add_rounded, color: AppColors.auroraTeal),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 400.ms),

                const SizedBox(height: 36),

                // Submit Button
                CustomButton(
                  text: "Submit Profile",
                  color: AppColors.auroraTeal,
                  onPressed: () async {
                    if (nameController.text.isEmpty ||
                        gender == 'Select Gender' ||
                        phoneController.text.isEmpty ||
                        emailController.text.isEmpty ||
                        clinicController.text.isEmpty ||
                        degreesController.text.isEmpty ||
                        bioController.text.isEmpty ||
                        doctorIdFile == null ||
                        documentFiles.isEmpty) {
                      Get.snackbar(
                        "Required Fields",
                        "Please fill all fields and upload credentials.",
                        backgroundColor: AppColors.errorRed.withOpacity(0.2),
                        colorText: AppColors.starWhite,
                        borderColor: AppColors.errorRed.withOpacity(0.4),
                        borderWidth: 1,
                        borderRadius: 12,
                        margin: const EdgeInsets.all(16),
                      );
                      return;
                    }

                    final docPaths = documentFiles.map((e) => e.path).toList();

                    final therapist = TherapistModel(
                      name: nameController.text,
                      gender: gender,
                      phone: phoneController.text,
                      altPhone: altPhoneController.text,
                      email: emailController.text,
                      clinic: clinicController.text,
                      degrees: degreesController.text,
                      bio: bioController.text,
                      experience: experienceController.text,
                      specialization: specializationController.text,
                      fees: feesController.text,
                      documentPaths: docPaths,
                      doctorIdPath: doctorIdFile!.path,
                    );

                    final box = Hive.box<TherapistModel>('therapists');
                    await box.add(therapist);

                    Get.snackbar(
                      "Success",
                      "Profile details submitted successfully!",
                      backgroundColor: AppColors.auroraTeal.withOpacity(0.15),
                      colorText: AppColors.starWhite,
                      borderColor: AppColors.auroraTeal.withOpacity(0.3),
                      borderWidth: 1,
                      borderRadius: 12,
                      margin: const EdgeInsets.all(16),
                    );
                    Get.offAll(() => const TherapistListPage(),
                        transition: Transition.rightToLeftWithFade);
                  },
                ),

                const SizedBox(height: 16),

                // Other Actions Grid/Row
                CustomButton(
                  color: AppColors.cosmicIndigo,
                  text: "Therapist Profiles",
                  icon: Icons.list_alt_rounded,
                  onPressed: () {
                    Get.offAll(() => const TherapistListPage(),
                        transition: Transition.rightToLeftWithFade);
                  },
                ),

                const SizedBox(height: 16),

                CustomButton(
                  color: AppColors.errorRed.withOpacity(0.15),
                  text: "Log Out",
                  icon: Icons.logout_rounded,
                  onPressed: () {
                    Get.snackbar(
                      "Logged Out",
                      "You have been successfully logged out.",
                      backgroundColor: AppColors.cosmicIndigo.withOpacity(0.8),
                      colorText: AppColors.starWhite,
                    );
                    Get.offAll(() => const UserTherapistChoicePage(),
                        transition: Transition.rightToLeftWithFade);
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.auroraTeal, size: 20),
        const SizedBox(width: 10),
        Text(
          title,
          style: AppTypography.headlineMedium.copyWith(
            color: AppColors.auroraTeal,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: AppTypography.bodyLarge.copyWith(color: AppColors.starWhite),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.auroraTeal, size: 20),
        labelText: hint,
        labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.moonGray),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.glassBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.auroraTeal, width: 1.5),
        ),
      ),
    );
  }
}
