import 'package:flutter/material.dart';
import 'package:jobconnect/presentation/theme/app_theme.dart';

/// Écran pour afficher les informations du profil company
/// Responsabilité unique: Affichage des données du profil (lecture seule)
class ProfileEditScreen extends StatelessWidget {
  final dynamic user;

  const ProfileEditScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informations du Profil'),
        backgroundColor: AppTheme.primaryBlue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Avatar
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Icon(
                  Icons.business,
                  size: 60,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Section Infos (Lecture seule)
            _buildInfoCard(
                'Nom de l\'Entreprise', user.name ?? 'Non disponible'),
            const SizedBox(height: 16),
            _buildInfoCard('Email', user.email ?? 'Non disponible'),
            const SizedBox(height: 16),
            _buildInfoCard('Téléphone', user.phone ?? 'Non défini'),
            const SizedBox(height: 16),
            _buildInfoCard('Adresse', user.address ?? 'Non définie'),
            const SizedBox(height: 16),
            _buildInfoCard('Ville', user.city ?? 'Non définie'),
            const SizedBox(height: 16),
            _buildInfoCard('Pays', user.country ?? 'Non défini'),
            const SizedBox(height: 16),
            _buildInfoCard('Code Postal', user.postalCode ?? 'Non défini'),
            const SizedBox(height: 16),
            _buildInfoCard('Type', user.role ?? 'Non défini'),
            const SizedBox(height: 32),

            // Message info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                border: Border.all(color: Colors.blue[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.blue[600]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Pour modifier vos informations, contactez l\'administrateur du système.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.blue[600],
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
