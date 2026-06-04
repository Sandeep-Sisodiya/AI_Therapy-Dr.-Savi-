import 'package:ai_therapy/Controllers/user_controller.dart';
import 'package:ai_therapy/Widgets/custom_button.dart';
import 'package:ai_therapy/custom_background.dart';
import 'package:ai_therapy/onBoarding/customize_attributes_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';
import 'package:get/get.dart';

import '../app_theme.dart';
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
                        const SizedBox(height: 10),
                        Text(
                          "What's on your mind today?",
                          textAlign: TextAlign.center,
                          style: AppTypography.displayMedium,
                        ).animate().fadeIn(duration: 500.ms),

                        const SizedBox(height: 12),

                        Text(
                          "Feel free to pick as many as you like",
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyMedium,
                        ).animate().fadeIn(delay: 200.ms, duration: 500.ms),

                        const SizedBox(height: 28),

                        _buildIssuesChips(specificIssues)
                            .animate()
                            .fadeIn(delay: 400.ms, duration: 600.ms),

                        const Spacer(),
                        const SizedBox(height: 20),

                        CustomButton(
                          text: "CONTINUE",
                          onPressed: () {
                            Get.to(const CustomizeAttributesScreen(
                              saveDetails: false,
                            ));
                          },
                        ),
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
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: issues
          .map((issue) => Obx(
                () {
                  final isSelected = userController.userIssues.contains(issue);
                  return GestureDetector(
                    onTap: () async {
                      if (await Vibration.hasVibrator() ?? false) {
                        Vibration.vibrate(duration: 100);
                      }
                      if (userController.userIssues.contains(issue)) {
                        userController.userIssues.remove(issue);
                      } else {
                        userController.addIssue(issue);
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.auroraLavender.withOpacity(0.2)
                            : AppColors.glassWhite,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.auroraLavender
                              : AppColors.glassBorder,
                          width: isSelected ? 1.5 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.auroraLavender.withOpacity(0.2),
                                  blurRadius: 12,
                                  spreadRadius: -2,
                                ),
                              ]
                            : [],
                      ),
                      child: Text(
                        issue,
                        style: AppTypography.labelMedium.copyWith(
                          color: isSelected
                              ? AppColors.starWhite
                              : AppColors.moonGray,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ))
          .toList(),
    );
  }
}
