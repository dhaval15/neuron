import 'package:flutter/material.dart';

import 'extended_node.dart';

class NodeWidget extends StatelessWidget {
  final ExtendedNode node;

  const NodeWidget(this.node);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: OverflowBox(
        maxWidth: 300,
        maxHeight: 300,
        child: Tooltip(
          message: node.title,
          child: Text(
            node.title,
            style: TextStyle(
              backgroundColor:
                  Colors.black.withOpacity(node.highlight ? 0.6 : 0.05),
              color: Colors.white.withOpacity(node.highlight ? 0.7 : 0.1),
              fontWeight: FontWeight.w300,
              fontSize: 15,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
