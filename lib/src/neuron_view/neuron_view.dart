import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:org_extras/org_extras.dart';
import '../network/network.dart';
import 'package:d3_force_flutter/d3_force_flutter.dart' as force;

import 'extended_node.dart';
import 'force_simulation_config.dart';
import 'neuron_config.dart';
import 'node_widget.dart';

class NeuronView extends StatefulWidget {
  final Neuron neuron;

  const NeuronView({
    required this.neuron,
  });
  @override
  _NeuronViewState createState() => _NeuronViewState();
}

class _NeuronViewState extends State<NeuronView>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late final force.ForceSimulation<ExtendedNode> simulation;
  late final List<force.Edge<ExtendedNode>> edges;
  late final List<int> edgeCounts;
  late final Map<String, int> levels;
  late final Map<String, int> weights;
  int maxEdgeCount = 0;
  int i = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    levels = NeuronUtils.calculateLevels(widget.neuron);
    weights = NeuronUtils.calculateWeights(widget.neuron);
    final nodes = widget.neuron.nodes.map((e) => e.extend()).toList();
    ExtendedNode find(String id) {
      return nodes.firstWhere((element) => id == element.id);
    }

    final size = MediaQuery.of(context).size;
    edges = widget.neuron.links
        .map((e) => force.Edge<ExtendedNode>(
            source: find(e.start), target: find(e.end)))
        .toList();

    simulation = ForceSimulationConfig().toSimulation(size, edges, nodes);

    _ticker = this.createTicker((_) {
      i++;
      // if (i% 10 != 0) return;
      setState(() {
        simulation.tick();
      });
    })
      ..start();

    edgeCounts = List.filled(nodes.length, 0);
    for (int i = 0; i < edges.length; i++) {
      final edge = edges[i];
      edge.index = i;
      edgeCounts[edge.source.index!] += 1;
      edgeCounts[edge.target.index!] += 1;
    }
    for (final count in edgeCounts) {
      if (count > maxEdgeCount) maxEdgeCount = count;
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void startTicker() => _ticker..start();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: NeuronTheme.of(context).backgroundColor,
      child: InteractiveViewer(
        child: SimulationCanvas(
          linkStrokeWidth: NeuronTheme.of(context).strokeWidth,
          linkColor: NeuronTheme.of(context).linkColor,
          children: [
            for (final node in simulation.nodes) buildNodeContainer(node),
          ],
        ),
      ),
    );
  }

  Widget buildNodeContainer(ExtendedNode node) {
    final double weight =
        maxEdgeCount == 0 ? 0 : edgeCounts[node.index!] / maxEdgeCount;
    return NodeContainer(
      level: levels[node.id]!,
      node: node,
      weight: weight,
      edges: edges.where((element) => element.source.id == node.id).toList(),
      simulation: simulation,
      weightLevel: weights[node.id]!,
    );
  }
}

class NodeContainer extends StatelessWidget {
  final int level;
  final ExtendedNode node;
  final double weight;
  final int weightLevel;
  final List<force.Edge> edges;
  final force.ForceSimulation simulation;

  const NodeContainer({
    required this.level,
    required this.node,
    required this.weight,
    required this.edges,
    required this.simulation,
    required this.weightLevel,
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
          print('Double');
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
