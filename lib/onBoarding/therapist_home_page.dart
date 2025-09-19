import 'dart:io';
import 'package:ai_therapy/onBoarding/therapist_list_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart

import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import '../Models/therapist_model.dart';
import '../Widgets/custom_button.dart';
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
        builder: (_) => SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    final XFile? file =
                    await _picker.pickImage(source: ImageSource.gallery);
                    if (file != null) onPicked(File(file.path));
                  } catch (e) {
                    Get.snackbar("Error", "Failed to pick image: $e",
                        snackPosition: SnackPosition.BOTTOM);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    final XFile? file =
                    await _picker.pickImage(source: ImageSource.camera);
                    if (file != null) onPicked(File(file.path));
                  } catch (e) {
                    Get.snackbar("Error", "Failed to capture image: $e",
                        snackPosition: SnackPosition.BOTTOM);
                  }
                },
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF5DBAC), Color(0xFFFFE4E1)]),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset("assets/ai3.png", height: 150),
                  const SizedBox(height: 15),
                  Text(
                    "Therapist Profile",
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Name
                  _buildTextField("Full Name", nameController, Icons.badge),

                  const SizedBox(height: 15),

                  // Gender
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => SafeArea(
                          child: Wrap(
                            children: ['Male', 'Female', 'Other']
                                .map((g) => ListTile(
                              title: Text(g),
                              onTap: () {
                                setState(() {
                                  gender = g;
                                });
                                Navigator.pop(context);
                              },
                            ))
                                .toList(),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black, width: 1.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(gender,
                              style: GoogleFonts.poppins(
                                  fontSize: 16, color: Colors.black87)),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Phone
                  _buildTextField("Phone Number", phoneController, Icons.phone),
                  const SizedBox(height: 15),

                  // Alternate Phone
                  _buildTextField("Alternate Phone (Optional)", altPhoneController, Icons.phone_android),
                  const SizedBox(height: 15),

                  // Email
                  _buildTextField("Email ID", emailController, Icons.email),
                  const SizedBox(height: 15),

                  // Clinic / Hospital
                  _buildTextField("Clinic/Hospital Address", clinicController, Icons.location_on),
                  const SizedBox(height: 15),

                  // Degrees
                  _buildTextField("Degrees", degreesController, Icons.school),
                  const SizedBox(height: 15),

                  // Bio
                  _buildTextField("Bio", bioController, Icons.info, maxLines: 5),
                  const SizedBox(height: 15),

                  // Extra professional details
                  _buildTextField("Years of Experience", experienceController, Icons.calendar_today),
                  const SizedBox(height: 15),
                  _buildTextField("Specialization", specializationController, Icons.medical_services),
                  const SizedBox(height: 15),
                  _buildTextField("Consultation Fees", feesController, Icons.attach_money),
                  const SizedBox(height: 20),

                  // Document Upload
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Upload Document Proofs",
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      ...documentFiles
                          .map((file) => Stack(
                        children: [
                          Image.file(file, width: 70, height: 70, fit: BoxFit.cover),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  documentFiles.remove(file);
                                });
                              },
                              child: const CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.red,
                                child: Icon(Icons.close, size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ))
                          .toList(),
                      GestureDetector(
                        onTap: () => _chooseImage((file) => setState(() => documentFiles.add(file))),
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          child: const Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Doctor ID Upload
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Upload Doctor ID",
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                  doctorIdFile != null
                      ? Stack(
                    children: [
                      Image.file(doctorIdFile!, width: 100, height: 100, fit: BoxFit.cover),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              doctorIdFile = null;
                            });
                          },
                          child: const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.close, size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                      : GestureDetector(
                    onTap: () => _chooseImage((file) => setState(() => doctorIdFile = file)),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: const Icon(Icons.add),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Submit button
                  CustomButton(
                    text: "Submit Profile",
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
                        Get.snackbar("Error", "Please fill all required fields",
                            snackPosition: SnackPosition.BOTTOM);
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

                      Get.snackbar("Success", "Profile submitted successfully",
                          snackPosition: SnackPosition.BOTTOM);
                      Get.offAll(() => const TherapistListPage(),
                          transition: Transition.rightToLeftWithFade);
                    },
                  ),

                  const SizedBox(height: 30),
                  CustomButton(
                    color: Color(0xFF611D8A),
                    text: "Therapist Profiles",
                    onPressed: () {
                      Get.offAll(() => const TherapistListPage(),
                          transition: Transition.rightToLeftWithFade);
                    },
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    color: Color(0xFF314846),
                    text: "LogOut",
                    onPressed: () {
                      Get.snackbar("Success", "Logged out successfully");
                      Get.offAll(() => const UserTherapistChoicePage(),
                          transition: Transition.rightToLeftWithFade);
                    },
                  ),
                  const SizedBox(height: 30),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, IconData icon,
      {int maxLines = 1}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.black87),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black54),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
