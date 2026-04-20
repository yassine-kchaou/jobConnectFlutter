import 'package:flutter/material.dart';

/// Utilitaire pour les statuts de candidatures
/// Responsabilité unique: Conversion statut → label + couleur
class ApplicationStatusHelper {
  /// Retourne le label en français pour un statut
  static String getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return 'Acceptée';
      case 'rejected':
        return 'Rejetée';
      case 'contract_signed':
        return 'Contrat signé';
      case 'started':
        return 'En cours';
      case 'finished':
        return 'Terminée';
      case 'pending':
      default:
        return 'En attente';
    }
  }

  /// Retourne la couleur associée au statut
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
      case 'contract_signed':
      case 'finished':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'started':
        return Colors.blue;
      case 'pending':
      default:
        return Colors.orange;
    }
  }

  /// Retourne une couleur avec opacité pour le background
  static Color getStatusBackgroundColor(String status) {
    return getStatusColor(status).withValues(alpha: 0.2);
  }
}
