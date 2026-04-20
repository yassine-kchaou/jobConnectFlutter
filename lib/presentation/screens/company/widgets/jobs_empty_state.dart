import 'package:flutter/material.dart';
import 'package:jobconnect/presentation/theme/app_theme.dart';

/// Widget pour afficher une offre d'emploi (vide)
/// Responsabilité unique: Affichage de l'état vide des offres
class JobsEmptyState extends StatelessWidget {
  final VoidCallback onCreateJobPressed;

  const JobsEmptyState({
    Key? key,
    required this.onCreateJobPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune offre publiée',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Créez votre première offre d\'emploi',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onCreateJobPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text('Créer une offre'),
            ),
          ],
        ),
      ),
    );
  }
}
