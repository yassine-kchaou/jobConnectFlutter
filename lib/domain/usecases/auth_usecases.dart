import 'package:dartz/dartz.dart';
import 'package:jobconnect/core/errors/failures.dart';
import 'package:jobconnect/domain/entities/user_entity.dart';
import 'package:jobconnect/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  Future<Either<Failure, AuthResponse>> call(String email, String password) {
    return repository.login(email, password);
  }
}

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase({required this.repository});

  Future<Either<Failure, AuthResponse>> call(Map<String, dynamic> data) {
    return repository.signup(data); // envoie tout l'objet "user + resume"
  }
}

class GetUserUseCase {
  final AuthRepository repository;

  GetUserUseCase({required this.repository});

  Future<Either<Failure, User>> call(String userId) {
    return repository.getUser(userId);
  }
}

class UploadAvatarUseCase {
  final AuthRepository repository;

  UploadAvatarUseCase({required this.repository});

  Future<Either<Failure, String>> call(String userId, String filePath) {
    return repository.uploadAvatar(userId, filePath);
  }
}

class UploadIdentityPicUseCase {
  final AuthRepository repository;

  UploadIdentityPicUseCase({required this.repository});

  Future<Either<Failure, String>> call(String userId, String filePath) {
    return repository.uploadIdentityPic(userId, filePath);
  }
}
