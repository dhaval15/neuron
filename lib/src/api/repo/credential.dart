import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Credential {
  static const _storage = FlutterSecureStorage();
  final String userId;
  final String password;
  const Credential(this.userId, this.password);
  static Future addCredential(Credential credential) async {
    return _storage.write(key: credential.userId, value: credential.password);
  }

  static Future deleteCredential(String userId) async {
    return _storage.delete(key: userId);
  }

  static Future<List<Credential>> getAllCredentials() async {
    final data = await _storage.readAll();
    return data.entries.map((e) => Credential(e.key, e.value)).toList();
  }

  static Future<Credential> getDefault() async {
    final data = await _storage.readAll();
    final entry = data.entries.first;
    return Credential(entry.key, entry.value);
  }
}
