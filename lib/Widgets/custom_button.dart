import 'package:ai_therapy/constants.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color? color;
  const CustomButton(
      {super.key,
        required this.text,
        required this.onPressed,
        this.color = buttonColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              blurRadius:2,
            )
          ],
          border: Border.all(
        color: Colors.black,
          width: 3,
        ),
        ),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}