import 'package:jobconnect/core/errors/failures.dart';

/// Abstraction pour gérer les erreurs de manière centralisée
/// Responsabilité unique: Convertir exceptions → Failures
///
/// Respecte DIP: Les repositories dépendent de cette abstraction
/// Respecte SRP: Une seule responsabilité = gestion d'erreurs
abstract class ErrorHandler {
  /// Convertit une exception en Failure typée
  ///
  /// Supporte:
  /// - DioException → ServerFailure ou NetworkFailure
  /// - FormatException → ValidationFailure
  /// - Exception générique → ServerFailure
  Failure handle(dynamic exception);
}
