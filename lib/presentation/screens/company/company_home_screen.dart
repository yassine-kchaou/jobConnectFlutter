import 'package:flutter/material.dart';
import 'package:jobconnect/presentation/theme/app_theme.dart';
import 'widgets/jobs_tab.dart';
import 'widgets/candidates_tab.dart';
import 'widgets/profile_tab.dart';

/// Écran principal de l'entreprise
/// Responsabilité unique: Orchestration des 3 tabs (Offres, Candidats, Profil)
class CompanyHomeScreen extends StatefulWidget {
  const CompanyHomeScreen({Key? key}) : super(key: key);

  @override
  State<CompanyHomeScreen> createState() => _CompanyHomeScreenState();
}

class _CompanyHomeScreenState extends State<CompanyHomeScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      floatingActionButton: _buildFab(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  /// Construire le FAB (Floating Action Button)
  Widget? _buildFab() {
    // Le FAB n'est affiché que pour la tab des offres (index 0)
    if (_selectedTabIndex != 0) return null;

    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, '/create-job');
      },
      backgroundColor: AppTheme.primaryBlue,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  /// Construire la bottom navigation bar
  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedTabIndex,
      onTap: (index) {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: AppTheme.primaryBlue,
      unselectedItemColor: Colors.black54,
      elevation: 8,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.work_outline),
          label: 'Mes offres',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          label: 'Candidats',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'Profil',
        ),
      ],
    );
  }

  /// Construire le contenu du body selon la tab sélectionnée
  Widget _buildBody() {
    switch (_selectedTabIndex) {
      case 0:
        return JobsTab(
          onCreateJobPressed: () {
            Navigator.pushNamed(context, '/create-job');
          },
        );
      case 1:
        return const CandidatesTab();
      case 2:
        return const ProfileTab();
      default:
        return JobsTab(
          onCreateJobPressed: () {
            Navigator.pushNamed(context, '/create-job');
          },
        );
    }
  }
}
