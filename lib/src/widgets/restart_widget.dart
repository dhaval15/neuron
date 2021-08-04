import 'package:flutter/material.dart';

class RestartWidget extends StatefulWidget {
  final WidgetBuilder builder;

  const RestartWidget({required this.builder});

  @override
  _RestartWidgetState createState() => _RestartWidgetState();

  static _RestartWidgetState of(BuildContext context) =>
      context.findAncestorStateOfType<_RestartWidgetState>()!;
}

class _RestartWidgetState extends State<RestartWidget> {
  void restart() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
