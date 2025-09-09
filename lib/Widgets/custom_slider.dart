import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../constants.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(leadingText,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: sliderGreen,
                    )),
                Text(trailingText,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: sliderGreen,
                    )),
              ],
            ),
          ),
          Slider(
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
            activeColor: sliderGreen,
            inactiveColor: sliderGreen.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
