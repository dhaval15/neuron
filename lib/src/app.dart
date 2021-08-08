import 'package:flutter/material.dart';
import 'api/shared_pref.dart';
import 'api/api.dart';
import 'neuron_view/neuron_config.dart';
import 'styles/styles.dart';
import 'screens/screens.dart';
import 'widgets/widgets.dart';
import 'package:path/path.dart';

class NeuronApp extends StatelessWidget {
  const NeuronApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    FileApi.linuxBaseDir = '/home/dhaval/Dev/Write';
    return RestartWidget(
      builder: (_) => SchemeProvider(
        scheme: Schemes.withName(SharedPrefWidget.of(context).scheme),
        builder: (context, scheme) {
          return FutureBuilder<String>(
            future: FileApi.getBaseDir(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final root = snapshot.data!;
                final prefs = SharedPrefWidget.of(context);
                final neuronRepo = prefs.brainRepo;
                final neuronPath =
                    neuronRepo == null ? '' : join(root, neuronRepo);
                return Providers(
                  data: [
                    RepoApi(root),
                    NeuronApi(neuronPath),
                  ],
                  child: NeuronThemeProvider(
                    theme: NeuronTheme(
                      strokeWidth: 1,
                      size: 30,
                      linkColor: Colors.grey.withOpacity(0.5),
                      highlightColor: Colors.indigo,
                      backgroundColor: Color(0xFF161616),
                    ),
                    child: MaterialApp(
                      title: 'Neuron',
                      theme: scheme.theme,
                      initialRoute: Screens.EXPLORE,
                      onGenerateRoute: Screens.onGenerateRoute,
                      debugShowCheckedModeBanner: false,
                    ),
                  ),
                );
              }
              return MaterialApp(
                title: 'Neuron',
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  body: SafeArea(
                    child: Center(
                      child: BouncingDotsIndiactor(),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
