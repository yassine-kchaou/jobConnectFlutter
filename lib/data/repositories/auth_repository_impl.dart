import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:jobconnect/core/errors/failures.dart';
import 'package:jobconnect/data/datasources/auth_remote_datasource.dart';
import 'package:jobconnect/domain/entities/user_entity.dart';
import 'package:jobconnect/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AuthResponse>> login(
    String email,
    String password,
  ) async {
    try {
      print('[AuthRepository] Attempting login for email: $email');
      final authResponseModel = await remoteDataSource.login(email, password);
      print('[AuthRepository] Login successful');
      return Right(
        AuthResponse(
          token: authResponseModel.token,
          user: authResponseModel.user.toEntity(),
        ),
      );
    } catch (e) {
      print('[AuthRepository] Login failed: $e');
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> signup(
    Map<String, dynamic> data,
  ) async {
    try {
      print('[AuthRepository] Attempting signup');
      final authResponseModel = await remoteDataSource.signup(data);
      print('[AuthRepository] Signup successful');
      return Right(
        AuthResponse(
          token: authResponseModel.token,
          user: authResponseModel.user.toEntity(),
        ),
      );
    } catch (e) {
      print('[AuthRepository] Signup failed: $e');
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, User>> getUser(String userId) async {
    try {
      final userModel = await remoteDataSource.getUser(userId);
      return Right(userModel.toEntity());
    } catch (e) {
      print('[AuthRepository] GetUser failed: $e');
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, String>> uploadAvatar(
    String userId,
    String filePath,
  ) async {
    try {
      final avatarPath = await remoteDataSource.uploadAvatar(userId, filePath);
      return Right(avatarPath);
    } catch (e) {
      print('[AuthRepository] UploadAvatar failed: $e');
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, String>> uploadIdentityPic(
    String userId,
    String filePath,
  ) async {
    try {
      final idPath = await remoteDataSource.uploadIdentityPic(userId, filePath);
      return Right(idPath);
    } catch (e) {
      print('[AuthRepository] UploadIdentityPic failed: $e');
      return Left(_handleException(e));
    }
  }

  Failure _handleException(dynamic e) {
    if (e is DioException) {
      final statusCode = e.response?.statusCode ?? 0;

      // Essayer d'extraire le message du backend de plusieurs endroits
      String message;
      if (e.response?.data is Map) {
        message = e.response?.data?['message'] ??
            e.response?.data?['error'] ??
            e.response?.data?['msg'] ??
            _getDioErrorMessage(e);
      } else {
        message = _getDioErrorMessage(e);
      }

      print(
          '[AuthRepository] DioException - Status: $statusCode, Message: $message');

      switch (statusCode) {
        case 400:
          return ServerFailure(message: message);
        case 401:
          // Pour 401, afficher un message convivial
          if (message.toLowerCase().contains('user not found')) {
            return ServerFailure(message: 'Email ou mot de passe incorrect');
          }
          if (message.toLowerCase().contains('password')) {
            return ServerFailure(message: 'Email ou mot de passe incorrect');
          }
          return ServerFailure(message: message);
        case 404:
          return ServerFailure(message: message);
        case 500:
          return ServerFailure(message: message);
        default:
          return ServerFailure(message: 'Erreur de connexion: $statusCode');
      }
    }

    if (e is ServerFailure) {
      return e;
    }

    print('[AuthRepository] Unknown error: ${e.toString()}');
    return UnknownFailure(message: e.toString());
  }

  String _getDioErrorMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Délai de connexion dépassé';
      case DioExceptionType.sendTimeout:
        return 'Délai d\'envoi dépassé';
      case DioExceptionType.receiveTimeout:
        return 'Délai de réception dépassé';
      case DioExceptionType.badResponse:
        return 'Réponse invalide du serveur';
      case DioExceptionType.cancel:
        return 'Requête annulée';
      case DioExceptionType.connectionError:
        return 'Erreur de connexion - Vérifiez votre connexion Internet';
      case DioExceptionType.unknown:
        return 'Erreur inconnue';
      default:
        return 'Une erreur est survenue';
    }
  }
}
