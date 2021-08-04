import 'package:flutter/material.dart';

import 'explore_screen.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

class Screens {
  // Root
  static const HOME = '/home';
  static const SETTINGS = '/settings';
  static const EXPLORE = '/explore';

  static Map<String, Widget Function(BuildContext context, Object? data)>
      _builders = {
    HOME: (context, args) => HomeScreen(),
    SETTINGS: (context, args) => SettingsScreen(),
    EXPLORE: (context, args) => ExploreScreen(),
  };

  static Route? onGenerateRoute(RouteSettings settings) {
    print(
        'Screen Changed : ${settings.name} with arguments (${settings.arguments.runtimeType})');
    final builder = _builders[settings.name];
    if (builder != null)
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => builder(context, settings.arguments),
      );
    return null;
  }
}

extension NavigatorStateExtension on NavigatorState {
  void popTo(String routeName) => popUntil(ModalRoute.withName(routeName));
}
