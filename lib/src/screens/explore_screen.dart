import 'package:flutter/material.dart';
import 'package:org_extras/org_extras.dart';

import '../api/api.dart';
import '../neuron_view/neuron_view.dart';
import '../widgets/widgets.dart';

class ExploreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Neuron>(
          future: Providers.of<NeuronApi>(context).fetchNeuron(),
          builder: (context, snapshot) {
            if (snapshot.hasData) return NeuronView(neuron: snapshot.data!);
            return Center(
              child: BouncingDotsIndiactor(),
            );
          },
        ),
      ),
    );
  }
}
