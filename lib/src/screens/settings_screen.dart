import 'package:flutter/material.dart';
import '../api/api.dart';
import '../styles/styles.dart';
import '../widgets/widgets.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = SharedPrefWidget.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const LabeledDivider(label: 'GENERAL'),
              DropdownField(
                label: 'Theme',
                options: Schemes.all.map((e) => e.name).toList(),
                value: SchemeProvider.of(context).scheme.name,
                onChanged: (text) {
                  SchemeProvider.of(context).scheme = Schemes.withName(text);
                  prefs.scheme = text;
                },
              ),
              RepoField(
                repos: Providers.of<RepoApi>(context).getRepos(),
                label: 'Repo',
                value: prefs.brainRepo,
                onChanged: (text) {
                  if (text != RepoField.NOT_SELECTED)
                    prefs.brainRepo = text;
                  else
                    prefs.brainRepo = null;
                  RestartWidget.of(context).restart();
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class RepoField extends StatelessWidget {
  static const NOT_SELECTED = 'Not Selected';
  final String label;
  final String? value;
  final void Function(String) onChanged;
  final Future<List<Repo>> repos;

  const RepoField({
    this.label = 'Repo',
    required this.value,
    required this.onChanged,
    required this.repos,
  });
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Repo>>(
      future: repos,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.length > 0) {
          final options =
              snapshot.data!.map((e) => e.path.split('/').last).toList();
          options.insert(0, NOT_SELECTED);
          return DropdownField(
            label: label,
            options: options,
            value: value ?? NOT_SELECTED,
            onChanged: onChanged,
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: BouncingDotsIndiactor(),
          );
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
          child: Text('No Repo added yet'),
        );
      },
    );
  }
}

class NotebookField extends StatelessWidget {
  static const NOT_SELECTED = 'Not Selected';
  final String label;
  final String? value;
  final void Function(String) onChanged;
  final Future<List<String>> notebooks;

  const NotebookField({
    this.label = 'Repo',
    required this.value,
    required this.onChanged,
    required this.notebooks,
  });
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: notebooks,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.length > 0) {
          final options = snapshot.data!;
          options.insert(0, NOT_SELECTED);
          return DropdownField(
            label: label,
            options: options,
            value: value ?? NOT_SELECTED,
            onChanged: onChanged,
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: BouncingDotsIndiactor(),
          );
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
          child: Text('No Notebook added yet'),
        );
      },
    );
  }
}
