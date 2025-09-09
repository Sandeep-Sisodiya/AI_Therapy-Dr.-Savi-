import 'package:ai_therapy/Controllers/user_controller.dart';
import 'package:ai_therapy/Widgets/custom_button.dart';
import 'package:ai_therapy/custom_background.dart';
import 'package:ai_therapy/onBoarding/customize_attributes_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';
import 'package:get/get.dart';

import '../constants.dart';

class SelectUserIssues extends StatefulWidget {
  const SelectUserIssues({super.key});

  @override
  State<SelectUserIssues> createState() => _SelectUserIssuesState();
}

class _SelectUserIssuesState extends State<SelectUserIssues> {
  late UserController userController;

  @override
  void initState() {
    userController = Get.put(UserController(), permanent: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        otherWidget: LayoutBuilder(builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "🧣What’s on your mind today❓",
                          // 🧠🧣🌹🍉🍓💢
                          textAlign: TextAlign.center,
                          style: GoogleFonts.chewy(
                            fontSize: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.fontSize ??
                                48,
                            color: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.color ??
                                Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "👉Feel free to pick as many options as you like👈",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.kaushanScript(
                            fontSize: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.fontSize ??
                                24,
                            color: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.color ??
                                Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        _buildIssuesChips(specificIssues),
                        const Spacer(),
                        CustomButton(
                            text: "CONTINUE",
                            onPressed: () {
                              Get.to(const CustomizeAttributesScreen(
                                saveDetails: false,
                              ));
                            })
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildIssuesChips(List<String> issues) {
    //user wrap widget to display the chips
    return Wrap(
      spacing: 10,
      runSpacing: 5,
      children: issues
          .map((issue) => Obx(
                () => ChoiceChip(
                  showCheckmark: false,
                  selected: userController.userIssues.contains(issue),
                  backgroundColor: userController.userIssues.contains(issue)
                      ? buttonColor
                      : Colors.transparent,
                  onSelected: (value) async {
                    if (await Vibration.hasVibrator() ?? false) {
                      Vibration.vibrate(
                          duration: 100); // short vibration for feedback
                    }
                    if (userController.userIssues.contains(issue)) {
                      userController.userIssues.remove(issue);
                    } else {
                      userController.addIssue(issue);
                    }
                  },
                  label: Text(
                    issue,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: userController.userIssues.contains(issue)
                              ? Colors.white
                              : textColor,
                        ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}
