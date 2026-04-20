import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobconnect/presentation/bloc/job_bloc.dart';
import 'package:jobconnect/presentation/theme/app_theme.dart';
import 'company/widgets/job_card.dart';
import 'company/widgets/job_search_filters.dart';

/// Tab pour rechercher et explorer toutes les offres d'emploi
/// Responsabilité unique: Affichage et recherche des offres disponibles
class SearchJobsTab extends StatefulWidget {
  const SearchJobsTab({Key? key}) : super(key: key);

  @override
  State<SearchJobsTab> createState() => _SearchJobsTabState();
}

class _SearchJobsTabState extends State<SearchJobsTab> {
  @override
  void initState() {
    super.initState();
    _loadAllJobs();
  }

  void _loadAllJobs() {
    context.read<JobBloc>().add(const FetchAllJobsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _loadAllJobs();
      },
      child: CustomScrollView(
        slivers: [
          // AppBar fixe
          SliverAppBar(
            pinned: true,
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: AppTheme.primaryBlue,
            title: const Text('Explorer les offres'),
            centerTitle: true,
          ),

          // Filtres de recherche
          SliverToBoxAdapter(
            child: JobSearchFilters(onReload: _loadAllJobs),
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
                            onPressed: _loadAllJobs,
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
                if (state.jobs.isEmpty) {
                  return _buildEmptyState(context);
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final job = state.jobs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: JobCard(job: job),
                      );
                    },
                    childCount: state.jobs.length,
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

  Widget _buildEmptyState(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Aucune offre trouvée',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Essayez de modifier vos filtres',
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
