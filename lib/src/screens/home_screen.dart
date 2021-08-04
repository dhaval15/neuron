import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neuron/src/api/api.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'screens.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    final neuron = await Providers.of<NeuronApi>(context).fetchNeuron();
    final json = RoamNeuronConverter().encode(neuron);
    final data = JsonEncoder().convert({
      'type': 'graphdata',
      'data': json,
    });

    final serverStream = NeuronServer.start();
    serverStream.listen((server) {
      server.send(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Neuron'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(Screens.SETTINGS);
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: WebView(
          initialUrl: 'https://neuron-f4414.web.app/',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
