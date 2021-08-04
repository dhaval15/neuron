import 'package:flutter/material.dart';
import '../styles/styles.dart';

class LabeledDivider extends StatelessWidget {
  final double startIndent, endIndent, verticleIndent, horizontalIndent;
  final String label;
  final Color? dividerColor;

  const LabeledDivider({
    this.startIndent = 8,
    this.endIndent = 8,
    this.verticleIndent = 16,
    this.horizontalIndent = 12,
    this.dividerColor,
    required this.label,
  });
  @override
  Widget build(BuildContext context) {
    final scheme = Scheme.of(context);
    final divider = Expanded(
      child: Container(
        color: dividerColor ?? scheme.onBackground.withOpacity(0.5),
        height: 0.5,
      ),
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: startIndent),
        divider,
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalIndent, vertical: verticleIndent),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              letterSpacing: 1,
              color: dividerColor ?? scheme.onBackground.withOpacity(0.8),
            ),
          ),
        ),
        divider,
        SizedBox(width: endIndent),
      ],
    );
  }
}
