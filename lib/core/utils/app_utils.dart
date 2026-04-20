// Utilitaires pour la validation et formatage
class ValidationUtils {
  static bool isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  static bool isValidPhone(String phone) {
    return RegExp(r'^[0-9+\-\s]{10,}$').hasMatch(phone);
  }
}

// Utilitaires pour le formatage des dates
class DateUtils {
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  static String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }

  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} ans ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} mois ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} jours ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} heures ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'À l\'instant';
    }
  }
}

// Utilitaires pour les devises
class CurrencyUtils {
  static String formatCurrency(double amount) {
    return '${amount.toStringAsFixed(2)} €';
  }

  static String formatCurrencyShort(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M €';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}k €';
    }
    return '${amount.toStringAsFixed(0)} €';
  }
}
