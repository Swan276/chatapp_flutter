import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class SecureStoreService {
  SecureStoreService(this._storage);

  @factoryMethod
  factory SecureStoreService.init() {
    AndroidOptions getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final secureStorage = FlutterSecureStorage(aOptions: getAndroidOptions());
    return SecureStoreService(secureStorage);
  }

  final FlutterSecureStorage _storage;

  Future<String?> get({required String key}) {
    return _storage.read(key: key);
  }

  Future<void> put({required String key, required String value}) {
    return _storage.write(key: key, value: value);
  }

  Future<void> delete({required String key}) {
    return _storage.delete(key: key);
  }
}
