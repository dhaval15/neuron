import 'dart:io';

import 'package:fudge/fudge.dart';

import 'credential.dart';

mixin RepoMixin {
  String get repoPath;
  Future<String> push(Credential? credential) async {
    if (Platform.isAndroid)
      return Fudge.push(
          Repo('', repoPath, credential?.userId, credential?.password));
    return '';
  }

  Future<String> pull(Credential? credential) async {
    if (Platform.isAndroid)
      return Fudge.pull(
          Repo('', repoPath, credential?.userId, credential?.password));
    return '';
  }

  Future<String> commit(String message) async {
    if (Platform.isAndroid) return Fudge.commit(repoPath, message);
    return '';
  }

  Future<String> addFile(String path) async {
    if (Platform.isAndroid) return Fudge.add(repoPath, path);
    return '';
  }

  Future<String> removeFile(String path) async {
    if (Platform.isAndroid) return Fudge.remove(repoPath, path);
    return '';
  }
}
