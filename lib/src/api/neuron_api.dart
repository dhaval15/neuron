import 'dart:io';

import 'package:org_extras/org_extras.dart';

class NeuronApi {
  final String repoPath;

  const NeuronApi(this.repoPath);

  Future<Neuron> fetchNeuron() => Future.microtask(() {
        final dir = Directory(repoPath);
        final paths = dir
            .listSync()
            .where((element) {
              return element.statSync().type == FileSystemEntityType.file &&
                  element.path.endsWith('.org');
            })
            .map((e) => e.path)
            .toList();
        return NeuronParser().parse(paths);
      });
}
