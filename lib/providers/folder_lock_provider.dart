import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class FolderLockProvider with ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final LocalAuthentication _localAuth = LocalAuthentication();

  // cache locked folder ids in memory for quick checks (optional)
  Map<String, bool> _locked = {};

  Future<void> loadLocks(List<String> folderIds) async {
    // optional: preload which folders locked
    for (var id in folderIds) {
      final val = await _secureStorage.read(key: 'folder_lock_$id');
      _locked[id] = (val != null && val.isNotEmpty);
    }
    notifyListeners();
  }

  bool isLocked(String folderId) {
    return _locked[folderId] ?? false;
  }

  Future<void> setPassword(String folderId, String password) async {
    await _secureStorage.write(key: 'folder_lock_$folderId', value: password);
    _locked[folderId] = true;
    notifyListeners();
  }

  Future<void> removePassword(String folderId) async {
    await _secureStorage.delete(key: 'folder_lock_$folderId');
    _locked[folderId] = false;
    notifyListeners();
  }

  Future<bool> verifyPassword(String folderId, String input) async {
    final saved = await _secureStorage.read(key: 'folder_lock_$folderId');
    final ok = saved != null && saved == input;
    if (ok) {
      // optionally mark unlocked for session:
      _locked[folderId] = false;
      notifyListeners();
    }
    return ok;
  }

  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics || await _localAuth.isDeviceSupported();
    } catch (_) { return false; }
  }

  Future<bool> authenticateBiometric() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Unlock folder',
        options: const AuthenticationOptions(biometricOnly: true),
      );
    } catch (e) {
      return false;
    }
  }
}
