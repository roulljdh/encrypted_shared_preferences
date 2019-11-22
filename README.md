# Encrypted Shared Preferences

This plugin stores Shared Preferences as encrypted values on device storage. It is decrypted when retrieved.
Make sure to target iOS 9.0 and later if you're going to deploy for iOS.

## Usage

Instantiate class:
```dart
EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences();
```

Save value:
```dart
encryptedSharedPreferences.setString("sample", "Hello, World!").then((bool success) {
    if (success) {
        print('success');
    } else {
        print('fail');
    }
});
```

Retrieve value:
```dart
encryptedSharedPreferences.getString("sample").then((String value) {
    print(value); // Prints Hello, World!
});
```

## Dependencies

This library depends on some other libraries :

* [shared_preferences](https://pub.dev/packages/shared_preferences)
* [flutter_string_encryption](https://pub.dev/packages/flutter_string_encryption)
