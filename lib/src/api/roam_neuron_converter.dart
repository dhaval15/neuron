import 'package:org_extras/org_extras.dart';

class RoamNeuronConverter extends NeuronConverter {
  @override
  Map<String, dynamic> encodeNode(Node node) {
    final category = node.file.split('/').last.split('.org')
      ..removeLast()
      ..join();
    final properties = node.level > 0
        ? {
            "CATEGORY": category.join(),
            "ID": node.id,
            "BLOCKED": "",
            "FILE": node.file,
            "PRIORITY": "B",
            "ITEM": node.level > 0 ? node.title : null,
          }
        : {
            "CATEGORY": category.join(),
            "ID": node.id,
            "BLOCKED": "",
            "FILE": node.file,
            "PRIORITY": "B",
          };
    return {
      "tags": [],
      "properties": properties,
      "level": node.level,
      "title": node.title,
      "file": node.file,
      "id": node.id,
    };
  }

  @override
  Map<String, dynamic> encodeLink(Link link) {
    return {
      "type": "id",
      "source": link.start,
      "target": link.end,
    };
  }

  @override
  Map<String, dynamic> encodeNeuron(Neuron neuron,
      List<Map<String, dynamic>> nodes, List<Map<String, dynamic>> links) {
    return {
      "tags": [],
      "nodes": nodes,
      "links": links,
    };
  }
}
