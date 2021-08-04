import 'package:org_extras/org_extras.dart';
import 'package:d3_force_flutter/d3_force_flutter.dart' as f;

class ExtendedNode extends f.Node implements Node {
  final String title;
  final String id;
  final String file;
  final int level;

  ExtendedNode({
    required this.level,
    required this.file,
    required this.title,
    required this.id,
  }) : super();

  @override
  int compareTo(Node other) {
    return this.id.compareTo(other.id);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'file': file,
        'level': level,
      };
}

extension NodeExtension on Node {
  ExtendedNode extend() {
    return ExtendedNode(
      level: level,
      id: id,
      title: title,
      file: file,
    );
  }
}
