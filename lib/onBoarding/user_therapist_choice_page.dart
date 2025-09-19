import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/custom_button.dart';
import 'login_page.dart';
import 'therapist_login_page.dart';

class UserTherapistChoicePage extends StatelessWidget {
  const UserTherapistChoicePage({super.key});

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
            colors: [
              Color(0xFFF5DBAC), // Light Peach
              Color(0xFFFFE4E1), // Misty Rose
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset("assets/robot.png", height: 400),
                  // const SizedBox(height: 20),
                  Text(
                    "Continue as",
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      shadows: const [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.brown,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Glassmorphic card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.brown.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        CustomButton(
                          text: "User",
                          onPressed: () {
                            Get.to(() => const LoginPage(),
                                transition: Transition.rightToLeftWithFade);
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: "Therapist",
                          onPressed: () {
                            Get.to(() => const TherapistLoginPage(),
                                transition: Transition.rightToLeftWithFade);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 80,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
