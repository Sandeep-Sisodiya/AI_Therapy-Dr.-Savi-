import 'package:ai_therapy/Widgets/custom_button.dart';
import 'package:ai_therapy/onBoarding/select_user_issues.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';
import 'package:get/get.dart';

import '../custom_background.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        otherWidget: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Image.asset(
                  "assets/ai3.png",
                  height: 200,
                ),
                // const SizedBox(
                //   height: 50,
                // ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3), // semi-transparent
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFE3B37C), // Correct ARGB format
                            blurRadius: 2,
                            // offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.black,
                          width: 3,
                        ),
                      ),
                      child: Text(
                        "Hello 👋",
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          shadows: [
                            const Shadow(
                              blurRadius: 5,
                              color: Colors.brown,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      "I’m Dr. SAVI\n❤️\n A space to think, feel, and grow.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.kaushanScript(
                        fontSize: Theme.of(context).textTheme.displayMedium?.fontSize ?? 36,
                        color: Colors.black,
                        shadows: const [
                          Shadow(
                            blurRadius: 1,
                            color: Colors.brown,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                CustomButton(
                    text: "LET'S DO IT TOGETHER?",
                    onPressed: ()async {
                      if (await Vibration.hasVibrator() ?? false) {
                      Vibration.vibrate(duration: 100); // short vibration for feedback
                      }
                      Get.to(
                            () => const SelectUserIssues(),
                        curve: Curves.easeIn,
                        transition: Transition.rightToLeftWithFade,
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}