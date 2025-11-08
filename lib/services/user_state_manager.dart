import 'package:flutter/material.dart';
import 'storage_service.dart';
import '../models/user.dart';
import '../models/user_auth.dart';

class UserStateManager extends ChangeNotifier {
  static final UserStateManager _instance = UserStateManager._internal();
  factory UserStateManager() => _instance;
  UserStateManager._internal();

  User? _currentUser;
  UserAuth? _currentUserAuth;
  Map<String, dynamic> _stats = {};

  // Getters
  User? get currentUser => _currentUser;
  UserAuth? get currentUserAuth => _currentUserAuth;
  Map<String, dynamic> get stats => _stats;

  // Initialize and load data
  void loadUserData() {
    _currentUser = StorageService.getCurrentUser();
    _currentUserAuth = StorageService.getCurrentUserAuth();
    _stats = StorageService.getStatistics();
    notifyListeners();
  }

  // Update user data and notify listeners
  void updateUserData() {
    loadUserData();
  }

  // Save user and update state
  void saveUser(User user) {
    StorageService.saveUser(user);
    loadUserData();
  }

  // Save user auth and update state
  void saveUserAuth(UserAuth userAuth) {
    StorageService.saveUserAuth(userAuth);
    loadUserData();
  }

  // Clear all data
  void clearData() {
    _currentUser = null;
    _currentUserAuth = null;
    _stats = {};
    notifyListeners();
  }
}
