library encrypted_shared_preferences;

import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EncryptedSharedPreferences {
  final cryptor = PlatformStringCryptor();
  final String randomKeyListKey = 'randomKeyList';

  Future<bool> setString(String key, String value) async {
    bool _success;

    /// Generate random key
    final String randomKey = await cryptor.generateRandomKey();

    /// Encrypt value
    final String encryptedValue = await cryptor.encrypt(value, randomKey);

    final prefs = await SharedPreferences.getInstance();

    /// Add generated random key to a list
    List<String> randomKeyList = prefs.getStringList(randomKeyListKey) ?? [];
    randomKeyList.add(randomKey);
    await prefs.setStringList(randomKeyListKey, randomKeyList);

    /// Save random key list index, We used encrypted value as key so we could use that to access it later
    int index = randomKeyList.length - 1;
    await prefs.setString(encryptedValue, index.toString());

    /// Save encrypted value
    await prefs.setString(key, encryptedValue).then((bool success) {
      _success = success;
    });

    return _success;
  }

  Future<String> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
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
    bool _success;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear().then((bool success) {
      _success = success;
    });
    return _success;
  }
  
}
