/// Abstraction pour tout client HTTP
/// Responsabilité unique: Définir le contrat d'une requête HTTP
///
/// Respecte ISP: Interface ségrégée avec 4 opérations basiques
/// Respecte DIP: Les datasources dépendent de cette abstraction
abstract class HttpClient {
  /// GET request
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  /// POST request
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  /// PUT request
  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  /// DELETE request
  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  /// Définir le token d'authentification
  void setToken(String token);

  /// Récupérer le token d'authentification
  String? getToken();

  /// Supprimer le token d'authentification
  void clearToken();
}
