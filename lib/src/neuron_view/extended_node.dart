import 'dart:math';

import 'package:flutter/material.dart';
import 'package:org_extras/org_extras.dart';
import 'package:d3_force_flutter/d3_force_flutter.dart' as f;

class ExtendedNode extends f.Node implements Node {
  final String title;
  final String id;
  final String file;
  final int level;
  final int ranId;

  ExtendedNode({
    required this.level,
    required this.file,
    required this.title,
    required this.id,
    required this.ranId,
  }) : super();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'file': file,
        'level': level,
      };

  @override
  bool operator ==(Object o) =>
      o is ExtendedNode &&
      x == o.x &&
      y == o.y &&
      index == o.index &&
      vx == o.vx &&
      vy == o.vy &&
      highlight == o.highlight;

  @override
  int get hashCode => hashValues(x, y, index, vx, vy);

  @override
  int compareTo(Node other) {
    return other.id.compareTo(this.id);
  }

  @override
  String toString() {
    return {
      'index': index,
      'ranId': ranId,
      'position': '($x, $y)',
      'velocity': '($vx, $vy)',
      'forces': '($fx,$fy)',
    }.toString();
  }
}

extension NodeExtension on Node {
  ExtendedNode extend() {
    return ExtendedNode(
      ranId: Random().nextInt(500),
      level: level,
      id: id,
      title: title,
      file: file,
    );
  }
}
