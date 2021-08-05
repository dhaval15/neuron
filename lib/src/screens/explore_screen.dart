import 'package:flutter/material.dart';
import 'package:neuron/src/neuron_view/neuron_controller.dart';
import 'package:org_extras/org_extras.dart';

import '../api/api.dart';
import '../neuron_view/neuron_view.dart';
import '../widgets/widgets.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late NeuronController controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Neuron>(
          future: Providers.of<NeuronApi>(context).fetchNeuron(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              controller = NeuronController(snapshot.data!);
              return NeuronView(
                controller: controller,
              );
            }
            return Center(
              child: BouncingDotsIndiactor(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.home),
        onPressed: () {
          controller.goHome();
        },
      ),
    );
  }
}
