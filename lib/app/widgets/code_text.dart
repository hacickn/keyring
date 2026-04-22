import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CodeText extends StatelessWidget {
  final String code;
  final double fontSize;
  final Color color;
  final double letterSpacing;

  const CodeText({
    super.key,
    required this.code,
    this.fontSize = 22,
    this.color = AppColors.ink,
    this.letterSpacing = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    final a = code.length >= 3 ? code.substring(0, 3) : code;
    final b = code.length > 3 ? code.substring(3) : '';

    final style = TextStyle(
      fontFamily: 'monospace',
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: color,
      letterSpacing: letterSpacing,
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(a, style: style),
        if (b.isNotEmpty) ...[
          SizedBox(width: fontSize * 0.3),
          Text(b, style: style),
        ],
      ],
    );
  }
}
