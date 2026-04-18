// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class SecureStorageService {
//   static const _storage = FlutterSecureStorage();

//   static const _keyToken = 'auth_token';
//   static const _keyTokenTime = 'auth_token_time';

//   // SAVE TOKEN + WAKTU
//   static Future<void> saveToken(String token) async {
//     await _storage.write(key: _keyToken, value: token);
//     await _storage.write(
//       key: _keyTokenTime,
//       value: DateTime.now().toIso8601String(),
//     );
//   }

//   // GET TOKEN
//   static Future<String?> getToken() async {
//     return await _storage.read(key: _keyToken);
//   }

//   // CEK EXPIRED (1 jam)
//   static Future<bool> isTokenExpired() async {
//     final timeStr = await _storage.read(key: _keyTokenTime);
//     if (timeStr == null) return true;

//     final savedTime = DateTime.parse(timeStr);
//     final now = DateTime.now();

//     return now.difference(savedTime).inMinutes > 55; // buffer
//   }

//   static Future<void> clearAll() async => _storage.deleteAll();
// }

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  static const _keyToken = 'auth_token';
  static const _keyTokenTime = 'auth_token_time';

  // SAVE TOKEN + WAKTU
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
    await _storage.write(
      key: _keyTokenTime,
      value: DateTime.now().toIso8601String(),
    );
  }

  // GET TOKEN
  static Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  // CEK EXPIRED (1 jam)
  static Future<bool> isTokenExpired() async {
    final timeStr = await _storage.read(key: _keyTokenTime);
    if (timeStr == null) return true;

    final savedTime = DateTime.parse(timeStr);
    final now = DateTime.now();

    return now.difference(savedTime).inMinutes > 55; // buffer
  }

  static Future<void> clearAll() async => _storage.deleteAll();
}
