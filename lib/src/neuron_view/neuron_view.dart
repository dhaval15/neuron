import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:neuron/src/neuron_view/neuron_controller.dart';
import '../network/network.dart';

import 'extended_node.dart';
import 'force_simulation_config.dart';
import 'neuron_config.dart';
import 'node_container.dart';

class NeuronView extends StatefulWidget {
  final NeuronController controller;

  const NeuronView({
    required this.controller,
  });
  @override
  _NeuronViewState createState() => _NeuronViewState();
}

class _NeuronViewState extends State<NeuronView>
    with SingleTickerProviderStateMixin {
  NeuronController get _controller => widget.controller;
  late final Ticker _ticker;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.of(context).size;
    _controller.simulation = ForceSimulationConfig().toSimulation(size);
    _controller.setupNeuron(_controller.parent);
    _runTicker();
  }

  void _runTicker() {
    for (int i = 0; i < 10; i++) {
      _controller.simulation.tick();
    }

    _ticker = this.createTicker((_) {
      setState(() {
        _controller.simulation.tick();
      });
    })
      ..start();
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
            for (final node in _controller.simulation.nodes)
              buildNodeContainer(node),
          ],
        ),
      ),
    );
  }

  Widget buildNodeContainer(ExtendedNode node) {
    final double weight = _controller.maxEdgeCount == 0
        ? 0
        : _controller.edgeCounts[node.index!] / _controller.maxEdgeCount;
    return NodeContainer(
      level: _controller.levels[node.id]!,
      node: node,
      weight: weight,
      edges: _controller.edges
          .where((element) => element.source.id == node.id)
          .toList(),
      simulation: _controller.simulation,
      weightLevel: _controller.weights[node.id]!,
      onFocusNode: _controller.focusNode,
    );
  }
}
