import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../app_theme.dart';

class CustomSlider extends StatelessWidget {
  final String leadingText;
  final String trailingText;
  final double defaultValue;
  final Function(double) onChanged;

  const CustomSlider({
    super.key,
    required this.leadingText,
    required this.trailingText,
    required this.defaultValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        decoration: GlassDecoration.card(borderRadius: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    leadingText,
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.auroraTeal,
                    ),
                  ),
                  Text(
                    trailingText,
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.auroraRose,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 6,
                activeTrackColor: AppColors.auroraLavender,
                inactiveTrackColor: AppColors.auroraLavender.withOpacity(0.15),
                thumbColor: AppColors.starWhite,
                overlayColor: AppColors.auroraLavender.withOpacity(0.12),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
                overlayShape:
                    const RoundSliderOverlayShape(overlayRadius: 22),
                trackShape: const RoundedRectSliderTrackShape(),
              ),
              child: Slider(
                value: defaultValue,
                onChanged: (value) {
                  Vibration.hasVibrator().then((hasVibrator) {
                    if (hasVibrator ?? false) {
                      Vibration.vibrate(duration: 50);
                    }
                  });
                  onChanged(value);
                },
                min: 0,
                max: 5,
                divisions: 5,
                label: defaultValue.round().toString(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
