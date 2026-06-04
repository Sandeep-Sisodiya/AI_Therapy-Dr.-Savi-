import 'package:flutter/material.dart';
import '../app_theme.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final Function onPressed;
  final Color? color;
  final Gradient? gradient;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.gradient,
    this.icon,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveGradient = widget.gradient ??
        (widget.color != null
            ? LinearGradient(
                colors: [
                  widget.color!,
                  HSLColor.fromColor(widget.color!)
                      .withLightness(
                        (HSLColor.fromColor(widget.color!).lightness - 0.08)
                            .clamp(0.0, 1.0),
                      )
                      .toColor(),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : AppGradients.primaryButtonGradient);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onPressed();
        },
        onTapCancel: () => _controller.reverse(),
        child: Container(
          height: 58,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: effectiveGradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: (widget.color ?? AppColors.auroraLavender)
                    .withOpacity(0.35),
                blurRadius: 16,
                spreadRadius: -2,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                ],
                Text(
                  widget.text,
                  style: AppTypography.button,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}