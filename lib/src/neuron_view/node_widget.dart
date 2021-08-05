import 'package:flutter/material.dart';
import 'package:org_extras/org_extras.dart';

class NodeWidget extends StatelessWidget {
  final Node node;

  const NodeWidget(this.node);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: OverflowBox(
        maxWidth: 300,
        maxHeight: 300,
        child: Text(
          node.title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.1),
            fontWeight: FontWeight.w300,
            fontSize: 15,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
