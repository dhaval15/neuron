import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/api/api.dart';
import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Fudge.log.listen((event) {
    print(event);
  });
  final preferences = await SharedPreferences.getInstance();
  runApp(SharedPrefWidget(
    preferences: preferences,
    child: NeuronApp(),
  ));
}
