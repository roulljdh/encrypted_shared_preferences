# Encrypted Shared Preferences

[![Pub](https://img.shields.io/pub/v/encrypted_shared_preferences.svg)](https://pub.dartlang.org/packages/encrypted_shared_preferences)

This plugin stores Shared Preferences as encrypted values. It is decrypted when retrieved. You could use this side by side with regular Shared Preferences.

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

### Remove value:

```dart
encryptedSharedPreferences.remove('sample').then((bool success) {
    if (success) {
        print('success');
    } else {
        print('fail');
    }
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

### Reload

```dart
encryptedSharedPreferences.reload();
```

### Optional: Pass custom SharedPreferences instance

```dart
/// You can pass a custom SharedPreferences instance (e.g. A newer version of SharedPreferences)
final prefs = await SharedPreferences.getInstance();
EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences(prefs: prefs);
```

### Access internal SharedPreferences instance

```dart
// You can access the internal SharedPreferences instance to invoke methods not exposed by regular EncryptedSharedPreferences
SharedPreferences instance = await encryptedSharedPreferences.getInstance();
int counter = 1;

/// Access SharedPreferences' setInt method
await instance.setInt('counter', counter);
```

### Modes of operation

Default mode is SIC AESMode.sic, you can override it using the mode named parameter:

```dart
EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences(mode: AESMode.cbc);
```

#### Supported modes are:

- CBC `AESMode.cbc`
- CFB-64 `AESMode.cfb64`
- CTR `AESMode.ctr`
- ECB `AESMode.ecb`
- OFB-64/GCTR `AESMode.ofb64Gctr`
- OFB-64 `AESMode.ofb64`
- SIC `AESMode.sic`
