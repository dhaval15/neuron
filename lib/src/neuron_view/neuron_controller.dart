import 'package:flutter/scheduler.dart';
import 'package:org_extras/org_extras.dart';
import 'package:d3_force_flutter/d3_force_flutter.dart' as force;

import 'extended_node.dart';
import 'force_simulation_config.dart';

class NeuronController {
  late final force.ForceSimulation<ExtendedNode> simulation;
  late List<force.Edge<ExtendedNode>> edges;
  late List<int> edgeCounts;
  late Map<String, int> levels;
  late Map<String, int> weights;
  int maxEdgeCount = 0;
  final Neuron parent;

  NeuronController(this.parent);

  void goHome() {
    setupNeuron(parent);
  }

  void focusNode(Node node) {
    final neuron = parent.focus(node.id);
    setupNeuron(neuron);
  }

  void setupNeuron(Neuron neuron) {
    levels = NeuronUtils.calculateLevels(neuron);
    weights = NeuronUtils.calculateWeights(neuron);
    final nodes = neuron.nodes.map((e) => e.extend()).toList();
    ExtendedNode find(String id) {
      return nodes.firstWhere((element) => id == element.id);
    }

    edges = neuron.links
        .map((e) => force.Edge<ExtendedNode>(
            source: find(e.start), target: find(e.end)))
        .toList();
    simulation.edgesAndNodes(edges, nodes, ForceSimulationConfig().distance);

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
}
