import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

export 'package:fudge/fudge.dart';

class FileApi {
  static String linuxBaseDir = '/home/dhaval/Dev/space/habbit/test_dir';
  static Future<String> getBaseDir() async {
    if (Platform.isLinux) return linuxBaseDir;
    if (Platform.isAndroid) {
      if (await Permission.storage.isGranted ||
          (await Permission.storage.request() == PermissionStatus.granted)) {
        final dir = await getExternalStorageDirectory();
        final path = join(dir!.parent.parent.parent.parent.path, 'Habbit');
        final baseDir = Directory(path);
        await baseDir.create();
        return path;
      }
      throw 'You have denied Access';
    }
    throw 'Not supported';
  }

  static Future<String> convertToRepoPath(String repoName) async {
    final dir = await getBaseDir();
    final path = join(dir, repoName);
    return path;
  }

  static Future<List<FileEntry>> fetchFiles(String path,
      {FileEntry? parent}) async {
    final dir = Directory(path);
    final entries = <FileEntry>[];
    await for (final entity in dir.list()) {
      final stat = await entity.stat();
      if (stat.type == FileSystemEntityType.directory) {
        final entry = FileEntry(
          name: entity.path.split('/').last,
          path: entity.path,
          entries: [],
          isDir: true,
          parent: parent,
        );
        entry.entries.addAll(await fetchFiles(entity.path, parent: entry));
        entries.add(entry);
      } else if (stat.type == FileSystemEntityType.file) {
        entries.add(FileEntry(
          name: entity.path.split('/').last,
          path: entity.path,
          entries: [],
          parent: parent,
          isDir: false,
        ));
      }
    }
    entries.sort(FileEntry.compare);
    return entries;
  }
}

class FileEntry {
  final FileEntry? parent;
  final String name;
  final String path;
  final List<FileEntry> entries;
  final bool isDir;

  FileEntry({
    this.parent,
    required this.name,
    required this.path,
    required this.entries,
    required this.isDir,
  });

  static int compare(FileEntry first, FileEntry second) =>
      first.name.compareTo(second.name);
}
