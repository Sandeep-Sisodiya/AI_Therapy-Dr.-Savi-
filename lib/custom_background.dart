import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBackground extends StatelessWidget {
  final Widget otherWidget;
  final bool maximizeHeight;
  const CustomBackground(
      {super.key, required this.otherWidget, this.maximizeHeight = true});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Column(
          children: [
            Container(
              height: maximizeHeight ? Get.height : 320,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF5DBAC), // Light Pink
                    Color(0xFFFFE4E1), // Misty Rose
                    // Color(0xFFFFF0F5), // Lavender Blush
                    // Color(0xFFFFFAFA), // Snow
                    // Color(0xFFFFFFFF), // Pure White
                  ],
                ),
              ),
            ),
          ],
        ),
        otherWidget,
      ],
    );
  }
}