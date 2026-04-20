/// Utilitaire pour formater les dates
/// Responsabilité unique: Conversion de dates en texte lisible
class DateFormatter {
  /// Formate une date ou string en format JJ/MM/AAAA
  ///
  /// Accepte:
  /// - DateTime: convertit directement
  /// - String: parse puis convertit
  /// - null: retourne 'Date inconnue'
  static String formatDate(dynamic date) {
    if (date == null) return 'Date inconnue';

    if (date is String) {
      try {
        final parsed = DateTime.parse(date);
        return _formatDateTime(parsed);
      } catch (e) {
        return date;
      }
    }

    if (date is DateTime) {
      return _formatDateTime(date);
    }

    return 'Date inconnue';
  }

  static String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  /// Formate une date avec l'heure
  static String formatDateWithTime(DateTime? dateTime) {
    if (dateTime == null) return 'Date inconnue';
    return '${_formatDateTime(dateTime)} à ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Retourne le temps écoulé (ex: "il y a 2 jours")
  static String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'À l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays}j';
    } else {
      return _formatDateTime(dateTime);
    }
  }
}
