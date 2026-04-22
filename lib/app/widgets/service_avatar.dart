import 'package:flutter/material.dart';

class ServiceAvatar extends StatelessWidget {
  final String letter;
  final Color color;
  final double size;
  final double borderRadius;

  const ServiceAvatar({
    super.key,
    required this.letter,
    required this.color,
    this.size = 44,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.42,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}
