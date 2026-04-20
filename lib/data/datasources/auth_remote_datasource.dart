import 'package:dio/dio.dart';
import 'package:jobconnect/core/config/api_client.dart';
import 'package:jobconnect/core/constants/api_constants.dart';
import 'package:jobconnect/data/models/user_model.dart';
import 'package:jobconnect/data/datasources/error_handler.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String email, String password);
  Future<AuthResponseModel> signup(Map<String, dynamic> data);
  Future<UserModel> getUser(String userId);
  Future<String> uploadAvatar(String userId, String filePath);
  Future<String> uploadIdentityPic(String userId, String filePath);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  final ErrorHandler errorHandler;

  AuthRemoteDataSourceImpl({
    required this.apiClient,
    required this.errorHandler,
  });

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    try {
      print('[AuthDataSource] Login request - Email: $email');

      final response = await apiClient.post(
        ApiConstants.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );

      print('[AuthDataSource] Login response status: ${response.statusCode}');
      print('[AuthDataSource] Login response data: ${response.data}');

      // Backend returns { token, userId, type, user? }
      final token = response.data['token'] ??
          response.data['access_token'] ??
          response.data['accessToken'];

      final userId = response.data['userId'] ??
          response.data['user_id'] ??
          response.data['id'];

      if (token == null || token.isEmpty) {
        throw Exception('Token not received from server');
      }

      if (token != null) {
        apiClient.setToken(token);
      }

      // Try to get user details from response, otherwise fetch separately
      UserModel userModel;
      if (response.data['user'] != null) {
        userModel = UserModel.fromJson(response.data['user']);
      } else if (userId != null) {
        userModel = await getUser(userId);
      } else {
        userModel = UserModel.fromJson({});
      }

      return AuthResponseModel(token: token ?? '', user: userModel);
    } on DioException catch (e) {
      print('[AuthDataSource] DioException caught');
      print('[AuthDataSource] Status Code: ${e.response?.statusCode}');
      print('[AuthDataSource] Response Data: ${e.response?.data}');

      // Ne pas lancer l'exception directement, laisser le repository la gérer
      rethrow;
    } catch (e) {
      print('[AuthDataSource] Unexpected error: $e');
      rethrow;
    }
  }

  @override
  Future<AuthResponseModel> signup(Map<String, dynamic> data) async {
    try {
      print('[AuthDataSource] Signup request data: $data');

      final response = await apiClient.post(
        ApiConstants.signupEndpoint,
        data: data,
      );

      print('[AuthDataSource] Signup response status: ${response.statusCode}');
      print('[AuthDataSource] Signup response data: ${response.data}');

      // Backend returns { token, userId, type, user? }
      final token = response.data['token'] ??
          response.data['access_token'] ??
          response.data['accessToken'];

      final userId = response.data['userId'] ??
          response.data['user_id'] ??
          response.data['id'];

      if (token != null) {
        apiClient.setToken(token);
      }

      UserModel userModel;
      if (response.data['user'] != null) {
        userModel = UserModel.fromJson(response.data['user']);
      } else if (userId != null) {
        userModel = await getUser(userId);
      } else {
        userModel = UserModel.fromJson({});
      }

      return AuthResponseModel(token: token ?? '', user: userModel);
    } on DioException catch (e) {
      print('[AuthDataSource] DioException on signup: ${e.type}');
      print('[AuthDataSource] Response status: ${e.response?.statusCode}');
      print('[AuthDataSource] Response data: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('[AuthDataSource] Unexpected error on signup: $e');
      rethrow;
    }
  }

  @override
  Future<UserModel> getUser(String userId) async {
    try {
      print('[AuthDataSource] Fetching user: $userId');

      final response = await apiClient.get(
        '${ApiConstants.getUserEndpoint}/$userId',
      );

      print('[AuthDataSource] User response status: ${response.statusCode}');
      print('[AuthDataSource] User response data: ${response.data}');

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      print('[AuthDataSource] DioException on getUser: ${e.type}');
      print('[AuthDataSource] Response status: ${e.response?.statusCode}');
      rethrow;
    } catch (e) {
      print('[AuthDataSource] Unexpected error on getUser: $e');
      rethrow;
    }
  }

  @override
  Future<String> uploadAvatar(String userId, String filePath) async {
    try {
      final response = await apiClient.uploadFile(
        ApiConstants.uploadAvatarEndpoint,
        filePath,
        fieldName: 'avatar',
      );
      return response.data['avatarPath'] ??
          response.data['avatar'] ??
          response.data['path'] ??
          '';
    } catch (e) {
      print('[AuthDataSource] Error uploading avatar: $e');
      rethrow;
    }
  }

  @override
  Future<String> uploadIdentityPic(String userId, String filePath) async {
    try {
      final response = await apiClient.uploadFile(
        ApiConstants.uploadIdentityPicEndpoint,
        filePath,
        fieldName: 'identityPic',
      );
      return response.data['identityPicPath'] ??
          response.data['identityPic'] ??
          response.data['path'] ??
          '';
    } catch (e) {
      print('[AuthDataSource] Error uploading identity pic: $e');
      rethrow;
    }
  }
}
