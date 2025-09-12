import 'dart:ui';

import 'package:ai_therapy/onBoarding/saved_summary_screen.dart';
import 'package:ai_therapy/onBoarding/video_conversation_mode_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Widgets/custom_button.dart';
import '../custom_background.dart';
import '../constants.dart';
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "🍁 Choose Your Mode",
                  // 🎯🦋🎀🎈🧣📍🍓🍉🍎🌹🍁🥀
                  textAlign: TextAlign.center,
                  style: GoogleFonts.chewy(
                    fontSize:
                        Theme.of(context).textTheme.displayLarge?.fontSize ??
                            48,
                    color: Theme.of(context).textTheme.displayLarge?.color ??
                        Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "👉 Select how you want to interact 👈",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.kaushanScript(
                    fontSize:
                        Theme.of(context).textTheme.displaySmall?.fontSize ??
                            24,
                    color: Theme.of(context).textTheme.displaySmall?.color ??
                        Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 80),

                // Chat Mode Button (blue-green)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        color: Colors.white.withOpacity(
                            0.6), // 5% white overlay for glass effect
                        child: Column(
                          children: [
                            SizedBox(height: 20,),
                            CustomButton(
                              text: "💬 Chat Mode",
                              onPressed: () =>
                                  Get.to(() => const ChatModeScreen()),
                              color: Color(0xBA117774),
                            ),
                            const SizedBox(height: 20),
                            CustomButton(
                              text: "🎙️ Voice Mode",
                              onPressed: () =>
                                  Get.to(() => const AudioConverstaionModeScreen()),
                              color: Color(0xFFC53367),
                            ),
                            const SizedBox(height: 20),
                            CustomButton(
                              text: "🤠 Visual Mode",
                              onPressed: () =>
                                  Get.to(() => const VideoConverstaionModeScreen()),
                              color: Color(0xFFB72B1E),
                            ),
                            SizedBox(height: 20,),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 80),

                // History Button (buttonColor theme)
                GestureDetector(
                  onTap: () => Get.to(() => ChatHistoryPage()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: buttonColor,
                      border: Border.all(color: Colors.black, width: 3),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.history, color: Colors.white, size: 26),
                        SizedBox(width: 8),
                        Text(
                          "History",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Get.to(() => SavedSummariesScreen()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: buttonColor,
                      border: Border.all(color: Colors.black, width: 3),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.history, color: Colors.white, size: 26),
                        SizedBox(width: 8),
                        Text(
                          "🗒️ Saved Summaries",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
