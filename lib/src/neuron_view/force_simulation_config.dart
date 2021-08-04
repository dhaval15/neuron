import 'dart:ui';

import 'package:d3_force_flutter/d3_force_flutter.dart';

class ForceSimulationConfig {
  final double phyllotaxisRadius;
  final double collideRadius;
  final ManyBody manyBody;
  final double distance;

  ForceSimulationConfig({
    this.phyllotaxisRadius = 20,
    this.collideRadius = 20,
    this.distance = 50,
    ManyBody? manyBody,
  }) : this.manyBody = manyBody ?? ManyBody(strength: -400);

  ForceSimulation<T> toSimulation<T extends Node>(
      Size size, List<Edge<T>> edges, List<T> nodes) {
    return ForceSimulation<T>(
      phyllotaxisX: size.width / 2,
      phyllotaxisY: size.height / 2,
      phyllotaxisRadius: phyllotaxisRadius,
    )
      ..nodes = nodes
      ..setForce('collide', Collide(radius: collideRadius))
      // ..setForce('radial', Radial(radius: 400))
      ..setForce('manyBody', manyBody)
      ..setForce(
          'center', Center(size.width / 2, size.height / 2, strength: 0.1))
      ..setForce(
        'edges',
        Edges(edges: edges, distance: distance),
      )
      ..setForce('x', XPositioning(x: size.width / 2))
      ..setForce('y', YPositioning(y: size.height / 2))
      ..alpha = 1;
  }
}
