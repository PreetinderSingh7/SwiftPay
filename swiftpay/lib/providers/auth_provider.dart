import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = true;
  String? _error;

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthProvider() {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final token = await ApiService.getToken();
    if (token == null) {
      _isLoading = false;
      notifyListeners();
    } else {
      // Token exists — assume logged in (add token validation if needed)
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(
      String name, String email, String phone, String password) async {
    _error = null;
    notifyListeners();

    final result = await ApiService.register(name, email, phone, password);

    if (result['success'] == true) {
      await ApiService.saveToken(result['token']);
      _user = UserModel.fromJson(result['user']);
      notifyListeners();
      return true;
    } else {
      _error = result['error'] ?? 'Registration failed.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _error = null;
    notifyListeners();

    final result = await ApiService.login(email, password);

    if (result['success'] == true) {
      await ApiService.saveToken(result['token']);
      _user = UserModel.fromJson(result['user']);
      notifyListeners();
      return true;
    } else {
      _error = result['error'] ?? 'Login failed.';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await ApiService.deleteToken();
    _user = null;
    notifyListeners();
  }
}