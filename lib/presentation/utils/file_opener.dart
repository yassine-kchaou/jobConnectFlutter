import 'package:url_launcher/url_launcher.dart';

/// Utilitaire pour ouvrir les fichiers externes
/// Responsabilité unique: Gestion des URLs et fichiers
class FileOpener {
  /// Ouvre une URL ou fichier en application externe
  ///
  /// Retourne true si l'ouverture a réussi, false sinon
  static Future<bool> openFile(String? filePath) async {
    if (filePath == null || filePath.isEmpty) {
      return false;
    }

    try {
      final Uri uri = Uri.parse(filePath);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Ouvre une URL dans le navigateur
  static Future<bool> openUrl(String? url) async {
    return openFile(url);
  }

  /// Envoie un email
  static Future<bool> sendEmail(String email,
      {String? subject, String? body}) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      },
    );

    return openFile(emailUri.toString());
  }
}
