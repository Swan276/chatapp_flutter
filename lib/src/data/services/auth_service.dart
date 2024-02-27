import 'dart:async';

import 'package:chatapp_ui/src/constants/constants.dart';
import 'package:chatapp_ui/src/data/datasources/remote_datasource.dart';
import 'package:chatapp_ui/src/data/entities/register_user.dart';
import 'package:chatapp_ui/src/data/entities/user.dart';
import 'package:chatapp_ui/src/data/services/secure_store_service.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class AuthService {
  AuthService(this.secureStoreService, this.remoteDatasource);

  final SecureStoreService secureStoreService;
  final RemoteDatasource remoteDatasource;

  User? _currentUser;

  User? get currentUser => _currentUser;

  Future<User?> isLoggedIn() async {
    if (await isTokenExists()) {
      if (_currentUser != null) return _currentUser;
      final user = await _getCurrentUser();
      if (user != null) {
        await _saveCurrentUser(user);
        return user;
      }
    }
    _deleteAuthInfo();
    return null;
  }

  Future<User> login({
    required String username,
    required String password,
  }) async {
    final user = await remoteDatasource.login(username, password);
    await _saveCurrentUser(user);
    return user;
  }

  Future<User> register({
    required String username,
    required String fullName,
    required String password,
  }) async {
    final user = await remoteDatasource.signup(
      RegisterUser(
        username: username,
        fullName: fullName,
        password: password,
      ),
    );
    await _saveCurrentUser(user);
    return user;
  }

  Future<void> logout() async {
    await _deleteAuthInfo();
  }

  Future<User?> _getCurrentUser() async {
    final userJson = await secureStoreService.get(key: currentUserKey);
    if (userJson == null) return null;
    final user = User.fromJson(userJson);
    return user;
  }

  Future<void> _saveCurrentUser(User user) {
    _currentUser = user;
    return secureStoreService.put(
      key: currentUserKey,
      value: user.toJson(),
    );
  }

  Future<void> _deleteAuthInfo() async {
    _currentUser = null;
    await Future.wait([
      secureStoreService.delete(key: currentUserKey),
      secureStoreService.delete(key: jwtTokenKey),
    ]);
  }

  Future<bool> isTokenExists() async {
    return (await secureStoreService.get(key: jwtTokenKey)) != null;
  }
}
