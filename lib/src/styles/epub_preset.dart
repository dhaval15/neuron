import 'package:flutter/material.dart';

class EpubPreset {
  final Color fontColor;
  final Color linkColor;
  final Color backgroundColor;
  final Brightness brightness;

  const EpubPreset({
    required this.fontColor,
    required this.linkColor,
    required this.backgroundColor,
    required this.brightness,
  });
}
