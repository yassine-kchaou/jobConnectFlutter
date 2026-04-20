import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobconnect/presentation/bloc/application_bloc.dart';
import 'package:jobconnect/presentation/theme/app_theme.dart';
import 'package:jobconnect/core/config/local_storage.dart';
import 'application_card.dart';

/// Widget pour la tab des candidatures reçues
/// Responsabilité unique: Affichage de la liste des candidatures
class CandidatesTab extends StatefulWidget {
  const CandidatesTab({Key? key}) : super(key: key);

  @override
  State<CandidatesTab> createState() => _CandidatesTabState();
}

class _CandidatesTabState extends State<CandidatesTab> {
  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  /// Charger les candidatures de l'entreprise
  void _loadApplications() async {
    final companyId = await LocalStorage().getUserId();
    if (companyId != null && mounted) {
      print('[CandidatesTab] Loading applications for company: $companyId');
      context.read<ApplicationBloc>().add(
            FetchApplicationsByEntrepriseIdEvent(entrepriseId: companyId),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _loadApplications();
      },
      child: CustomScrollView(
        slivers: [
          // AppBar fixe
          SliverAppBar(
            pinned: true,
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: AppTheme.primaryBlue,
            title: const Text('Candidatures reçues'),
            centerTitle: true,
          ),

          // Contenu
          BlocBuilder<ApplicationBloc, ApplicationState>(
            builder: (context, state) {
              // État de chargement
              if (state is ApplicationLoading) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                );
              }

              // État d'erreur
              if (state is ApplicationFailure) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Erreur',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _loadApplications,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                            ),
                            child: const Text('Réessayer'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              // Applications chargées
              if (state is ApplicationsLoaded) {
                if (state.applications.isEmpty) {
                  return _buildEmptyState(context);
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final application = state.applications[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: ApplicationCard(application: application),
                      );
                    },
                    childCount: state.applications.length,
                  ),
                );
              }

              // État par défaut (aucune candidature)
              return _buildEmptyState(context);
            },
          ),
        ],
      ),
    );
  }

  /// Construire l'état vide
  Widget _buildEmptyState(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Aucune candidature',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Les candidatures apparaîtront ici',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
