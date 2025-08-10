
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/folder_lock_provider.dart';

class LockDialog {
  static Future<bool> show(
      BuildContext context,
      String folderId, {
        String? folderName,
      }) async {
    final TextEditingController ctrl = TextEditingController();
    final lockProv = Provider.of<FolderLockProvider>(context, listen: false);

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_rounded,
                  size: 48,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 10),
                Text(
                  folderName ?? 'Protected Folder',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'Enter password or use biometrics to unlock.',
                  style: TextStyle(color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Password input field
                TextField(
                  controller: ctrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.vpn_key_rounded),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Buttons row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.fingerprint),
                        label: const Text('Biometrics'),
                        onPressed: () async {
                          final canBio = await lockProv.canCheckBiometrics();
                          if (!canBio) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Biometrics not available'),
                              ),
                            );
                            return;
                          }
                          final ok = await lockProv.authenticateBiometric();
                          if (ok) {
                            Navigator.of(ctx).pop(true);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.lock_open_rounded),
                        label: const Text('Unlock'),
                        onPressed: () async {
                          final ok = await lockProv.verifyPassword(
                            folderId,
                            ctrl.text.trim(),
                          );
                          if (ok) {
                            Navigator.of(ctx).pop(true);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Wrong password')),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Cancel button
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[600],
                  ),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        );
      },
    ).then((v) => v ?? false);
  }
}
