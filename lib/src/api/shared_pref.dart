import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefWidget extends StatelessWidget with SharedPrefMixin {
  final SharedPreferences _preferences;
  final Widget child;

  SharedPrefWidget({
    required SharedPreferences preferences,
    required this.child,
  }) : this._preferences = preferences;

  factory SharedPrefWidget.of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<SharedPrefWidget>()!;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

mixin SharedPrefMixin {
  SharedPreferences get _preferences;

  String get scheme => _preferences.getString('SCHEME') ?? 'Radiant Dark';

  set scheme(String value) {
    _preferences.setString('SCHEME', value);
  }

  String? get brainRepo => _preferences.getString('BRAIN_REPO');

  set brainRepo(String? value) {
    if (value != null)
      _preferences.setString('BRAIN_REPO', value);
    else
      _preferences.remove('BRAIN_REPO');
  }
}
