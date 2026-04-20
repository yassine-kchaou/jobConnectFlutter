class AppConstants {
  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String userRoleKey = 'user_role';
  static const String userEmailKey = 'user_email';
  static const String userNameKey = 'user_name';

  // Roles
  static const String employeeRole = 'employee';
  static const String companyRole = 'company';

  // Error messages
  static const String networkError =
      'Erreur réseau. Veuillez vérifier votre connexion.';
  static const String timeoutError =
      'Délai d\'expiration dépassé. Veuillez réessayer.';
  static const String serverError =
      'Erreur serveur. Veuillez réessayer plus tard.';
  static const String unauthorizedError =
      'Non autorisé. Veuillez vous reconnecter.';
  static const String notFoundError = 'Ressource non trouvée.';
  static const String validationError =
      'Erreur de validation. Veuillez vérifier vos données.';

  // UI constants
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const double headerHeight = 200.0;
}
