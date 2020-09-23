library encrypted_shared_preferences;

import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EncryptedSharedPreferences {
  final cryptor = PlatformStringCryptor();
  final String randomKeyListKey = 'randomKeyList';
  SharedPreferences prefs;

  /// Optional: Pass custom SharedPreferences instance
  EncryptedSharedPreferences({this.prefs});

  Future<SharedPreferences> getInstance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    /// If this.prefs null, use internal SharedPreferences instance
    prefs = this.prefs ?? prefs;

    return prefs;
  }

  Future<bool> setString(String key, String value) async {
    /// Generate random key
    final String randomKey = await cryptor.generateRandomKey();

    /// Encrypt value
    final String encryptedValue = await cryptor.encrypt(value, randomKey);

    final prefs = await getInstance();

    /// Add generated random key to a list
    List<String> randomKeyList = prefs.getStringList(randomKeyListKey) ?? [];
    randomKeyList.add(randomKey);
    await prefs.setStringList(randomKeyListKey, randomKeyList);

    /// Save random key list index, We used encrypted value as key so we could use that to access it later
    int index = randomKeyList.length - 1;
    await prefs.setString(encryptedValue, index.toString());

    /// Save encrypted value
    bool success = await prefs.setString(key, encryptedValue);

    return success;
  }

  Future<String> getString(String key) async {
    final prefs = await getInstance();
    String decrypted = '';

    try {
      /// Get encrypted value
      String encrypted = prefs.getString(key);

      if (encrypted != null) {
        /// Get random key list index using the encrypted value as key
        int index = int.parse(prefs.getString(encrypted));

        /// Get random key from random key list using the index
        List<String> randomKeyList = prefs.getStringList(randomKeyListKey);
        String randomKey = randomKeyList[index];

        /// Get decrypted value
        decrypted = await cryptor.decrypt(encrypted, randomKey);
      }
    } on MacMismatchException {
      /// Unable to decrypt (wrong key or forged data)
    }

    return decrypted;
  }

  Future<bool> clear() async {
    final prefs = await getInstance();

    /// Clear values
    bool success = await prefs.clear();

    return success;
  }

  Future reload() async {
    final prefs = await getInstance();

    /// Reload
    await prefs.reload();
  }
}
