import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobconnect/presentation/bloc/job_bloc.dart';
import 'package:jobconnect/presentation/theme/app_theme.dart';
import 'package:jobconnect/core/config/local_storage.dart';
import 'job_card.dart';
import 'job_search_filters.dart';

/// Widget pour le tab des offres d'emploi
/// Responsabilité unique: Affichage et chargement de la liste des offres
class JobsTab extends StatefulWidget {
  final VoidCallback onCreateJobPressed;

  const JobsTab({
    Key? key,
    required this.onCreateJobPressed,
  }) : super(key: key);

  @override
  State<JobsTab> createState() => _JobsTabState();
}

class _JobsTabState extends State<JobsTab> {
  String? _currentCompanyId;

  @override
  void initState() {
    super.initState();
    _loadUserJobs();
  }

  /// Charger les offres de l'utilisateur
  void _loadUserJobs() async {
    final companyId = await LocalStorage().getUserId();
    if (companyId != null && mounted) {
      setState(() => _currentCompanyId = companyId);
      print('[JobsTab] Loading jobs for company: $companyId');
      // Charger toutes les offres et filtrer côté frontend par companyId
      context.read<JobBloc>().add(const FetchAllJobsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _loadUserJobs();
      },
      child: CustomScrollView(
        slivers: [
          // AppBar fixe
          SliverAppBar(
            pinned: true,
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: AppTheme.primaryBlue,
            title: const Text('Mes offres d\'emploi'),
            centerTitle: true,
          ),

          // Filtres de recherche
          SliverToBoxAdapter(
            child: JobSearchFilters(onReload: _loadUserJobs),
          ),

          // Contenu
          BlocBuilder<JobBloc, JobState>(
            builder: (context, state) {
              // État de chargement
              if (state is JobLoading) {
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
              if (state is JobFailure) {
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
                            onPressed: _loadUserJobs,
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

              // Offres chargées
              if (state is JobsLoaded) {
                // Filtrer les offres créées par cette entreprise
                final userJobs = state.jobs
                    .where((job) => job.companyId == _currentCompanyId)
                    .toList();

                if (userJobs.isEmpty) {
                  return _buildEmptyState(context);
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final job = userJobs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: JobCard(
                          job: job,
                        ),
                      );
                    },
                    childCount: userJobs.length,
                  ),
                );
              }

              // État par défaut (aucune offre)
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
                onPressed: widget.onCreateJobPressed,
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
      ),
    );
  }
}
