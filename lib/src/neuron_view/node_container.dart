import 'package:d3_force_flutter/d3_force_flutter.dart' as f;
import 'package:flutter/material.dart';
import 'package:org_extras/org_extras.dart';
import '../network/network.dart';

import 'extended_node.dart';
import 'neuron_config.dart';
import 'node_widget.dart';

class NodeContainer extends StatelessWidget {
  final int level;
  final ExtendedNode node;
  final double weight;
  final int weightLevel;
  final List<f.Edge> edges;
  final f.ForceSimulation simulation;
  final void Function(Node node) onFocusNode;

  const NodeContainer({
    required this.level,
    required this.node,
    required this.weight,
    required this.edges,
    required this.simulation,
    required this.weightLevel,
    required this.onFocusNode,
  });
  @override
  Widget build(BuildContext context) {
    final factor = 20 + level * 10.0;
    return SimulationCanvasObject(
      weight: weight,
      constraints: BoxConstraints.tight(Size(40, 40)),
      node: node,
      edges: edges,
      child: NodeHitTester(
        node,
        onTap: () {
          print(node.title);
        },
        onDoubleTap: () {
          onFocusNode(node);
        },
        onLongTap: () {
          print('Long');
        },
        onDragUpdate: (update) {
          node
            ..fx = update.globalPosition.dx
            ..fy = update.globalPosition.dy;
          simulation..alpha = 0.3;
        },
        onDragEnd: (_) {
          node
            ..fx = null
            ..fy = null;
        },
        child: Center(
          child: Container(
            width: factor,
            height: factor,
            decoration: BoxDecoration(
              color: NeuronTheme.of(context).findColor(weightLevel),
              shape: BoxShape.circle,
            ),
            child: NodeWidget(node),
          ),
        ),
      ),
    );
  }
}
