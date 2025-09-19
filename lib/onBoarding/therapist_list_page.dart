import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import '../Models/therapist_model.dart';
import 'therapist_detail_page.dart';

class TherapistListPage extends StatelessWidget {
  const TherapistListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<TherapistModel>('therapists');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // lighter professional background
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        child: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, Box<TherapistModel> box, _) {
            if (box.values.isEmpty) {
              return Center(
                child: Text(
                  "No Therapist Profiles Available",
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700]),
                ),
              );
            }

            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                final therapist = box.getAt(index)!;

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white, // professional card background
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                    boxShadow: [
                      BoxShadow(
                        // color: Color(0xFF611D8A),
                        color: Colors.black,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Doctor photo
                      CircleAvatar(
                        radius: 45,
                        backgroundImage: FileImage(File(therapist.doctorIdPath)),
                      ),
                      const SizedBox(width: 20),
                      // Limited info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              therapist.name,
                              style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              therapist.specialization,
                              style: GoogleFonts.poppins(
                                  fontSize: 18, color: Colors.black54),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              therapist.clinic,
                              style: GoogleFonts.poppins(
                                  fontSize: 16, color: Colors.black45),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF611D8A),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () {
                                  Get.to(
                                        () => TherapistDetailPage(therapist: therapist),
                                    transition: Transition.rightToLeftWithFade,
                                  );
                                },
                                child: Text(
                                  "View Details",
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
