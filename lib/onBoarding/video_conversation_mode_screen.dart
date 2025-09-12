import 'package:ai_therapy/onBoarding/audio_conversation_page.dart';
import 'package:ai_therapy/constants.dart';
import 'package:ai_therapy/custom_background.dart';
import 'package:ai_therapy/onBoarding/video_conversation_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';
import 'package:get/get.dart';

import '../Controllers/user_controller.dart';

class VideoConverstaionModeScreen extends StatelessWidget {
  const VideoConverstaionModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: CustomBackground(
        otherWidget: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Image.asset("assets/robot.png"),
                    Text(
                      "Are You Ready!",
                      style: GoogleFonts.kaushanScript(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "How are you feeling today?",
                      style: GoogleFonts.kaushanScript(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    _mainButton(
                      context,
                      "Let's start Visual Conversation",
                      null,
                      Color(0xff061c18),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // _mainButton(
                    //     context, "Over Text Chat", Icons.chat, sliderGreen),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _mainButton(
      BuildContext context, String text, IconData? icon, Color color) {
    if (icon == null) {
      Get.find<UserController>().selectedConvMode.value = 1;
    } else {
      Get.find<UserController>().selectedConvMode.value = 0;
    }
    return GestureDetector(
      onTap: () async {
        // Vibrate using vibration package
        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate(duration: 100); // short vibration for feedback
        }

        Get.to(
              () => const VideoConversationPage(),
          curve: Curves.easeIn,
          transition: Transition.downToUp,
          // duration: const Duration(milliseconds: 300),
        );
      },
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: color.withOpacity(.2),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon == null
                  ? Image.asset(
                "assets/voice_chat.png",
                width: 35,
                height: 35,
              )
                  : Icon(
                icon,
                size: 30,
                color: sliderGreen,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                text,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: color,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
