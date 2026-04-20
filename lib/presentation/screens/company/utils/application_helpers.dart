/// Utilitaire pour gérer les statuts des candidatures
/// Responsabilité unique: Logique liée aux statuts
class ApplicationStatusHelper {
  /// Obtenir la couleur correspondant au statut
  static String getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return '#4CAF50'; // Vert
      case 'rejected':
        return '#F44336'; // Rouge
      case 'pending':
        return '#FF9800'; // Orange
      default:
        return '#9E9E9E'; // Gris
    }
  }

  /// Obtenir l'étiquette du statut en français
  static String getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return 'Acceptée';
      case 'rejected':
        return 'Rejetée';
      case 'pending':
        return 'En attente';
      default:
        return status;
    }
  }

  /// Vérifier si une candidature est en attente
  static bool isPending(String status) {
    return status.toLowerCase() == 'pending';
  }

  /// Vérifier si une candidature est acceptée
  static bool isAccepted(String status) {
    return status.toLowerCase() == 'accepted';
  }

  /// Vérifier si une candidature est rejetée
  static bool isRejected(String status) {
    return status.toLowerCase() == 'rejected';
  }
}

/// Utilitaire pour formater les dates
/// Responsabilité unique: Formatage des dates
class ApplicationDateFormatter {
  /// Formater une date de candidature
  static String formatDate(dynamic date) {
    if (date == null) return 'Date inconnue';

    if (date is String) {
      try {
        final parsed = DateTime.parse(date);
        final today = DateTime.now();
        final yesterday = DateTime.now().subtract(const Duration(days: 1));

        // Afficher "Aujourd'hui" ou "Hier"
        if (parsed.year == today.year &&
            parsed.month == today.month &&
            parsed.day == today.day) {
          return 'Aujourd\'hui à ${parsed.hour}:${parsed.minute.toString().padLeft(2, '0')}';
        }

        if (parsed.year == yesterday.year &&
            parsed.month == yesterday.month &&
            parsed.day == yesterday.day) {
          return 'Hier à ${parsed.hour}:${parsed.minute.toString().padLeft(2, '0')}';
        }

        // Sinon afficher le format court
        return '${parsed.day}/${parsed.month}/${parsed.year}';
      } catch (e) {
        return date;
      }
    }

    return 'Date inconnue';
  }

  /// Obtenir le temps écoulé depuis la candidature
  static String getTimeAgo(dynamic date) {
    if (date == null) return 'Il y a longtemps';

    if (date is String) {
      try {
        final parsed = DateTime.parse(date);
        final now = DateTime.now();
        final difference = now.difference(parsed);

        if (difference.inMinutes < 1) {
          return 'À l\'instant';
        } else if (difference.inMinutes < 60) {
          return 'Il y a ${difference.inMinutes}m';
        } else if (difference.inHours < 24) {
          return 'Il y a ${difference.inHours}h';
        } else if (difference.inDays < 7) {
          return 'Il y a ${difference.inDays}j';
        } else {
          return formatDate(date);
        }
      } catch (e) {
        return 'Il y a longtemps';
      }
    }

    return 'Il y a longtemps';
  }
}

/// Utilitaire pour filtrer les candidatures
/// Responsabilité unique: Logique de filtrage
class ApplicationFilterHelper {
  /// Filtrer les candidatures par statut
  static List<dynamic> filterByStatus(
    List<dynamic> applications,
    String status,
  ) {
    if (status == 'all') {
      return applications;
    }
    return applications
        .where((app) => app.status?.toLowerCase() == status.toLowerCase())
        .toList();
  }

  /// Filtrer les candidatures par nom de candidat
  static List<dynamic> filterByApplicantName(
    List<dynamic> applications,
    String name,
  ) {
    if (name.isEmpty) {
      return applications;
    }
    return applications
        .where((app) =>
            app.applicantName?.toLowerCase().contains(name.toLowerCase()) ??
            false)
        .toList();
  }

  /// Filtrer les candidatures par titre d'offre
  static List<dynamic> filterByJobTitle(
    List<dynamic> applications,
    String jobTitle,
  ) {
    if (jobTitle.isEmpty) {
      return applications;
    }
    return applications
        .where((app) =>
            app.jobTitle?.toLowerCase().contains(jobTitle.toLowerCase()) ??
            false)
        .toList();
  }
}
