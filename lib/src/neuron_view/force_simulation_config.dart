import 'dart:ui';

import 'package:d3_force_flutter/d3_force_flutter.dart';

class ForceSimulationConfig {
  final double phyllotaxisRadius;
  final double collideRadius;
  final ManyBody manyBody;
  final double distance;

  ForceSimulationConfig({
    this.phyllotaxisRadius = 20,
    this.collideRadius = 40,
    this.distance = 50,
    ManyBody? manyBody,
  }) : this.manyBody = manyBody ??
            ManyBody(
              distanceMin2: 40,
              strength: -50,
            );

  ForceSimulation<T> toSimulation<T extends Node>(Size size) {
    return ForceSimulation<T>(
      phyllotaxisX: size.width / 2,
      phyllotaxisY: size.height / 2,
      phyllotaxisRadius: phyllotaxisRadius,
    )
      ..setForce('collide', Collide(radius: collideRadius))
      ..setForce('radial', Radial(radius: 400))
      ..setForce('manyBody', manyBody)
      ..setForce(
          'center', Center(size.width / 2, size.height / 2, strength: 0.1))
      ..setForce('x', XPositioning(x: size.width / 2))
      ..setForce('y', YPositioning(y: size.height / 2))
      ..alpha = 1;
  }
}

extension ForceSimulationExtension on ForceSimulation {
  void edgesAndNodes<T extends Node>(
      List<Edge<T>> edges, List<T> nodes, double distance) {
    this.nodes = nodes;
    setForce('edges', Edges(edges: edges, distance: distance));
  }
}
