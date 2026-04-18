import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apps_marketplace_integration_backend/core/constants/api_constants.dart';
import 'package:apps_marketplace_integration_backend/core/services/secure_storage.dart';

class DioClient {
  static Dio? _instance;

  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: Duration(milliseconds: ApiConstants.connectTimeout),
        receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeout),
      ),
    );
    //-----------------------function 1
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SecureStorageService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
    //---------------------------------function 2 (refresh token otomatis, tapi belum sempurna)
    // dio.interceptors.add(
    //   InterceptorsWrapper(
    //     onRequest: (options, handler) async {
    //       String? token = await SecureStorageService.getToken();

    //       // 🔥 kalau token tidak ada / expired → ambil dari Firebase
    //       if (token == null || await SecureStorageService.isTokenExpired()) {
    //         final user = FirebaseAuth.instance.currentUser;

    //         if (user != null) {
    //           token = await user.getIdToken(true); // refresh
    //           await SecureStorageService.saveToken(token!);
    //           print("TOKEN REFRESH ✅");
    //         } else {
    //           print("USER NULL ❌");
    //         }
    //       } else {
    //         print("PAKAI TOKEN STORAGE ✅");
    //       }

    //       if (token != null) {
    //         options.headers['Authorization'] = 'Bearer $token';
    //       }

    //       handler.next(options);
    //     },
    //   ),
    // );
    //-----------------------function 3 (refresh token otomatis + logging lengkap)
    // dio.interceptors.add(
    //   InterceptorsWrapper(
    //     onRequest: (options, handler) async {
    //       print("🌐 REQUEST[${options.method}] => PATH: ${options.path}");

    //       String? token = await SecureStorageService.getToken();

    //       if (token == null || await SecureStorageService.isTokenExpired()) {
    //         final user = FirebaseAuth.instance.currentUser;
    //         if (user != null) {
    //           // Paksa ambil token baru dari Firebase
    //           token = await user.getIdToken(true);
    //           await SecureStorageService.saveToken(token!);
    //           print("TOKEN REFRESHED FROM FIREBASE ✅");
    //         }
    //       }

    //       if (token != null) {
    //         options.headers['Authorization'] = 'Bearer $token';
    //         // HAPUS COMMENT DI BAWAH UNTUK DEBUG (Hati-hati, jangan biarkan di production)
    //         // print("AUTH_TOKEN: Bearer $token");
    //       } else {
    //         print("NO TOKEN FOUND IN STORAGE OR FIREBASE ❌");
    //       }

    //       return handler.next(options);
    //     },
    //     onError: (DioException e, handler) {
    //       print(
    //         "❌ ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}",
    //       );
    //       print(
    //         "DATA: ${e.response?.data}",
    //       ); // Lihat alasan spesifik dari backend
    //       return handler.next(e);
    //     },
    //   ),
    // );
    return dio;
  }
}
