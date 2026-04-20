import 'package:jobconnect/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:jobconnect/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResponse>> login(String email, String password);
  Future<Either<Failure, AuthResponse>> signup(Map<String, dynamic> data);
  Future<Either<Failure, User>> getUser(String userId);
  Future<Either<Failure, String>> uploadAvatar(String userId, String filePath);
  Future<Either<Failure, String>> uploadIdentityPic(
      String userId, String filePath);
}

// Import Failure for the abstract class
