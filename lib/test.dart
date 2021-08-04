import 'dart:convert';
import 'dart:io';

import 'package:org_extras/org_extras.dart';

import 'src/api/neuron_server.dart';
import 'src/api/roam_neuron_converter.dart';

void main() async {
  final server = NeuronServer.start();
  const PATH = '/home/dhaval/Dev/Write/brain/';
  final dir = Directory(PATH);
  final paths = dir
      .listSync()
      .where((element) {
        return element.statSync().type == FileSystemEntityType.file &&
            element.path.endsWith('.org');
      })
      .map((e) => e.path)
      .toList();
  final neuron = NeuronParser().parse(paths);
  final data = RoamNeuronConverter().encode(neuron);
  server.listen((event) {
    event.send(JsonEncoder().convert({
      'type': 'graphdata',
      'data': data,
    }));
  });
}

void test() {
  const PATH = '/home/dhaval/Dev/Write/brain/';
  final dir = Directory(PATH);
  final paths = dir
      .listSync()
      .where((element) {
        return element.statSync().type == FileSystemEntityType.file &&
            element.path.endsWith('.org');
      })
      .map((e) => e.path)
      .toList();
  final neuron = NeuronParser().parse(paths);
  final nodes = neuron.nodes.toSet();
  final links = neuron.links.toSet();
  for (final link in links) {
    print('${link.start} => ${link.end}');
    print('${neuron.find(link.start).title} => ${neuron.find(link.end).title}');
  }
  for (final node in nodes) {
    print('======');
    print('ID    :     ${node.id}');
    print('LABEL :     ${node.title}');
    print('PATH  :     ${node.file}');
    print('LEVEL :     ${node.level}');
  }
  print('======================= Analysis =====================');
  final nodeSet = NeuronUtils.buildNodeSet(nodes);
  final startSet = NeuronUtils.buildStartSet(links);
  final endSet = NeuronUtils.buildEndSet(links);
  final rootSet = NeuronUtils.buildRootSet(startSet, endSet);
  final leafSet = NeuronUtils.buildLeafSet(startSet, endSet);
  final groupSet = NeuronUtils.buildGroupSet(startSet, endSet);
  final orphanSet = NeuronUtils.buildOrphanSet(nodeSet, groupSet);
  final parentSet = NeuronUtils.buildParentSet(rootSet, orphanSet);
  printLabel('Nodes');
  printSets(nodeSet, nodes);
  printLabel('Start');
  printSets(startSet, nodes);
  printLabel('End');
  printSets(endSet, nodes);
  printLabel('Root');
  printSets(rootSet, nodes);
  printLabel('Leaf');
  printSets(leafSet, nodes);
  printLabel('Group');
  printSets(groupSet, nodes);
  printLabel('Orphan');
  printSets(orphanSet, nodes);
  printLabel('Parent');
  printSets(parentSet, nodes);
}

void printLabel(String label) => print('\n=== $label ===\n');

void printSets(Set<String> data, Set<Node> nodes) {
  for (final e in data) {
    final node =
        nodes.firstWhere((element) => element.id == e, orElse: () => Node.none);
    if (node != Node.none)
      print('${node.title}');
    else
      print('Id : $e NOT FOUND');
  }
}
