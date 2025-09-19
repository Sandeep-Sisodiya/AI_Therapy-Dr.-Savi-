import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Models/therapist_model.dart';

class TherapistDetailPage extends StatelessWidget {
  final TherapistModel therapist;
  const TherapistDetailPage({super.key, required this.therapist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7), // soft professional background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () => _showImageDialog(context, therapist.doctorIdPath),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: FileImage(File(therapist.doctorIdPath)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  therapist.name,
                  style: GoogleFonts.poppins(
                      fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
              Center(
                child: Text(
                  therapist.specialization,
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 30),

              // Info Card
              _buildInfoCard([
                _buildDetail("Gender", therapist.gender),
                _buildDetail("Phone", therapist.phone),
                if (therapist.altPhone.isNotEmpty)
                  _buildDetail("Alternate Phone", therapist.altPhone),
                _buildDetail("Email", therapist.email),
                _buildDetail("Clinic/Hospital", therapist.clinic),
                _buildDetail("Degrees", therapist.degrees),
                _buildDetail("Experience", therapist.experience),
                _buildDetail("Consultation Fees", therapist.fees),
              ]),

              const SizedBox(height: 20),

              // Bio Card
              _buildCard(title: "Bio", child: Text(
                therapist.bio,
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87, height: 1.5),
              )),

              const SizedBox(height: 20),

              // Documents Card
              Center(
                child: _buildCard(
                  title: "Documents",
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: therapist.documentPaths.map((path) => GestureDetector(
                      onTap: () => _showImageDialog(context, path),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(path),
                            width: 300,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Card for general info
  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  // Generic Card with title
  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  // Detail row for info card
  Widget _buildDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: RichText(
        text: TextSpan(
          text: "$title: ",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 16),
          children: [TextSpan(
            text: value,
            style: GoogleFonts.poppins(fontWeight: FontWeight.normal, color: Colors.black87, fontSize: 16),
          )],
        ),
      ),
    );
  }

  // Show image in full-screen
  void _showImageDialog(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 3.0,
            child: Image.file(File(imagePath)),
          ),
        ),
      ),
    );
  }
}
