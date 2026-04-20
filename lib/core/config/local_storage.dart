import 'package:jobconnect/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  late SharedPreferences _prefs;

  factory LocalStorage() {
    return _instance;
  }

  LocalStorage._internal();

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setToken(String token) async {
    await _prefs.setString(AppConstants.tokenKey, token);
  }

  String? getToken() {
    return _prefs.getString(AppConstants.tokenKey);
  }

  Future<void> setUserId(String userId) async {
    await _prefs.setString(AppConstants.userIdKey, userId);
  }

  String? getUserId() {
    return _prefs.getString(AppConstants.userIdKey);
  }

  Future<void> setUserRole(String role) async {
    await _prefs.setString(AppConstants.userRoleKey, role);
  }

  String? getUserRole() {
    return _prefs.getString(AppConstants.userRoleKey);
  }

  Future<void> setUserEmail(String email) async {
    await _prefs.setString(AppConstants.userEmailKey, email);
  }

  String? getUserEmail() {
    return _prefs.getString(AppConstants.userEmailKey);
  }

  Future<void> setUserName(String name) async {
    await _prefs.setString(AppConstants.userNameKey, name);
  }

  String? getUserName() {
    return _prefs.getString(AppConstants.userNameKey);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }

  bool isLoggedIn() {
    return getToken() != null && getUserId() != null;
  }
}
