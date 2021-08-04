import 'package:flutter/material.dart';

class NeuronConfig {}

class NeuronThemeProvider extends StatelessWidget {
  final Widget child;
  final NeuronTheme theme;

  const NeuronThemeProvider({
    required this.child,
    required this.theme,
  });
  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class NeuronTheme {
  final double strokeWidth;
  final double size;
  final Color linkColor;
  final Color backgroundColor;

  static NeuronTheme of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<NeuronThemeProvider>()!.theme;

  const NeuronTheme({
    required this.strokeWidth,
    required this.size,
    required this.linkColor,
    required this.backgroundColor,
  });

  Color findColor(int level) {
    final effective = (level - 1) % 5;
    switch (effective) {
      case 0:
        return Colors.pink;
      case 1:
        return Colors.orangeAccent;
      case 2:
        return Colors.green;
      case 3:
        return Colors.deepOrange;
      case 4:
        return Colors.indigo;
    }
    return Colors.grey;
  }
}
