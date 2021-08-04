import 'dart:io';

import 'credential.dart';
import 'package:fudge/fudge.dart';
import 'package:path/path.dart';

class RepoApi {
  final String rootPath;

  RepoApi(this.rootPath);

  Future<List<Repo>> getRepos() async {
    final repoDir = Directory(rootPath);
    final List<Repo> repos = [];
    await for (final entity in repoDir.list()) {
      final stat = await entity.stat();
      if (stat.type == FileSystemEntityType.directory) {
        repos.add(Repo(null, entity.path));
      }
    }
    return repos;
  }

  String convertRepoToPath(String repoName) {
    final path = join(rootPath, repoName);
    return path;
  }

  Future<String> clone(
      String name, String remoteUrl, Credential? credential) async {
    final path = convertRepoToPath(name);
    final repo =
        Repo(remoteUrl, path, credential?.userId, credential?.password);
    return Fudge.clone(repo);
  }

  Future<String> pull(String name, Credential? credential) async {
    final path = convertRepoToPath(name);
    final repo = Repo('', path, credential?.userId, credential?.password);
    return Fudge.pull(repo);
  }

  Future checkUpstream(String name, Credential? credential) async {
    final path = convertRepoToPath(name);
    final repo = Repo('', path, credential?.userId, credential?.password);
    return Fudge.checkUpstream(repo);
  }

  Future<TrackingStatus> trackStatus(String name,
      [Credential? credential]) async {
    final path = convertRepoToPath(name);
    final repo = Repo('', path, credential?.userId, credential?.password);
    return Fudge.trackStatus(repo);
  }

  Future<String> push(String name, Credential? credential) async {
    final path = convertRepoToPath(name);
    final repo = Repo('', path, credential?.userId, credential?.password);
    return Fudge.push(repo);
  }

  Future<List<String>> fetchCommits(String path) async {
    return Fudge.fetchCommits(path);
  }

  Future<Map> status(String path) async {
    return Fudge.status(path);
  }
}
