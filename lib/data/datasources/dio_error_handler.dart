import 'package:dio/dio.dart';
import 'package:jobconnect/core/errors/failures.dart';
import 'package:jobconnect/data/datasources/error_handler.dart';

/// Implémentation concrète de ErrorHandler
/// Responsabilité unique: Convertir DioException → Failures
///
/// Respecte OCP: Extensible sans modification
/// Respecte SRP: Uniquement logique d'erreur Dio
class DioErrorHandler implements ErrorHandler {
  @override
  Failure handle(dynamic exception) {
    print('[DioErrorHandler] Handling error: ${exception.runtimeType}');

    if (exception is DioException) {
      return _handleDioException(exception);
    }

    if (exception is FormatException) {
      return ServerFailure(message: 'Format invalide: ${exception.message}');
    }

    // Fallback pour exceptions inattendues
    return ServerFailure(message: 'Erreur inconnue: ${exception.toString()}');
  }

  Failure _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return NetworkFailure('Délai dépassé. Vérifiez votre connexion.',
            message: 'erreur de réseau.');

      case DioExceptionType.connectionError:
        return NetworkFailure('Problème de connexion réseau.',
            message: 'erreur de réseau.');

      case DioExceptionType.badResponse:
        return _handleBadResponse(e.response);

      case DioExceptionType.cancel:
        return ServerFailure(message: 'Requête annulée.');

      case DioExceptionType.unknown:
        return ServerFailure(message: 'Erreur inconnue: ${e.message}');

      default:
        return ServerFailure(message: 'Erreur serveur: ${e.message}');
    }
  }

  Failure _handleBadResponse(Response? response) {
    if (response == null) {
      return ServerFailure(message: 'Réponse vide du serveur.');
    }

    final statusCode = response.statusCode ?? 0;
    final message = _getErrorMessage(response.data, statusCode);

    if (statusCode == 400 || statusCode == 422) {
      return ValidationFailure(message: message);
    }

    if (statusCode == 401 || statusCode == 403) {
      return AuthenticationFailure(message: message);
    }

    if (statusCode >= 500) {
      return ServerFailure(message: 'Erreur serveur ($statusCode): $message');
    }

    return ServerFailure(message: 'Erreur HTTP ($statusCode): $message');
  }

  String _getErrorMessage(dynamic data, int statusCode) {
    if (data is Map<String, dynamic>) {
      return data['message'] ??
          data['error'] ??
          data['msg'] ??
          'Erreur HTTP $statusCode';
    }
    return data?.toString() ?? 'Erreur HTTP $statusCode';
  }
}
