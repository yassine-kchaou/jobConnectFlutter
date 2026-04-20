import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobconnect/presentation/bloc/auth_bloc.dart';
import 'package:jobconnect/presentation/theme/app_theme.dart';
import '../profile_edit_screen.dart';

/// Widget pour la tab profil de l'entreprise
/// Responsabilité unique: Affichage du profil entreprise et déconnexion
class ProfileTab extends StatelessWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // AppBar fixe
        SliverAppBar(
          pinned: true,
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: AppTheme.primaryBlue,
          title: const Text('Profil Entreprise'),
          centerTitle: true,
        ),

        // Contenu du profil
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Avatar/Logo
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
                  const SizedBox(height: 24),

                  // Titre
                  Text(
                    'Entreprise',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 24),

                  // Bouton d'édition
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _navigateToProfileEdit(context);
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Modifier le profil'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Bouton de déconnexion
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        print('[ProfileTab] Logout button pressed');
                        _showLogoutConfirmation(context);
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Déconnexion'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Version de l'app
                  Center(
                    child: Text(
                      'JobConnect v1.0.0',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Naviguer vers l'écran d'édition de profil
  void _navigateToProfileEdit(BuildContext context) {
    // Récupérer l'utilisateur depuis le BLoC
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileEditScreen(user: authState.user),
        ),
      );
    }
  }

  /// Afficher le dialog de confirmation de déconnexion
  void _showLogoutConfirmation(BuildContext context) {
    print('[ProfileTab] Showing logout confirmation dialog');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter?'),
        actions: [
          TextButton(
            onPressed: () {
              print('[ProfileTab] Logout cancelled');
              Navigator.pop(context);
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              print('[ProfileTab] Logout confirmed, emitting AuthLogoutEvent');
              Navigator.pop(context);

              // Émettre l'événement de déconnexion
              context.read<AuthBloc>().add(const AuthLogoutEvent());
            },
            child: const Text(
              'Déconnexion',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
