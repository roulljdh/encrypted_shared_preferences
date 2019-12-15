# Encrypted Shared Preferences

[![Pub](https://img.shields.io/pub/v/encrypted_shared_preferences.svg)](https://pub.dartlang.org/packages/encrypted_shared_preferences)

This plugin stores Shared Preferences as encrypted values. It is decrypted when retrieved. You could use this side by side with regular Shared Preferences. Make sure to target iOS 9.0 and later if you're going to deploy for iOS.

## Usage

### Instantiate class:
```dart
EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences();
```

### Save value:
```dart
encryptedSharedPreferences.setString('sample', 'Hello, World!').then((bool success) {
    if (success) {
        print('success');
    } else {
        print('fail');
    }
});
```

### Retrieve value:
```dart
encryptedSharedPreferences.getString('sample').then((String value) {
    print(value); /// Prints Hello, World!
});
```

### Clear values:
```dart
/// Clears all values, including those you saved using regular Shared Preferences.
encryptedSharedPreferences.clear().then((bool success) {
    if (success) {
        print('success');
    } else {
        print('fail');
    }
});
```

## Dependencies

This library depends on some other libraries :

* [shared_preferences](https://pub.dev/packages/shared_preferences)
* [flutter_string_encryption](https://pub.dev/packages/flutter_string_encryption)
