import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobconnect/core/config/local_storage.dart';
import 'package:jobconnect/data/models/application_model.dart';
import 'package:jobconnect/presentation/bloc/application_bloc.dart';
import 'package:jobconnect/presentation/theme/app_theme.dart';
import 'package:jobconnect/presentation/utils/date_formatter.dart';
import 'package:jobconnect/presentation/utils/application_status_helper.dart';
import 'package:jobconnect/presentation/utils/file_opener.dart';
import 'package:jobconnect/presentation/screens/employee/widgets/detail_row.dart';

class MyApplicationsScreen extends StatefulWidget {
  const MyApplicationsScreen({Key? key}) : super(key: key);

  @override
  State<MyApplicationsScreen> createState() => _MyApplicationsScreenState();
}

class _MyApplicationsScreenState extends State<MyApplicationsScreen> {
  @override
  void initState() {
    super.initState();
    _loadMyApplications();
  }

  void _loadMyApplications() async {
    final userId = await LocalStorage().getUserId();
    if (userId != null && mounted) {
      context.read<ApplicationBloc>().add(
            FetchApplicationsByApplicantIdEvent(applicantId: userId),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Candidatures'),
        backgroundColor: AppTheme.primaryBlue,
      ),
      body: BlocBuilder<ApplicationBloc, ApplicationState>(
        builder: (context, state) {
          if (state is ApplicationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ApplicationsLoaded) {
            if (state.applications.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.applications.length,
              itemBuilder: (context, index) {
                return _buildApplicationCard(state.applications[index]);
              },
            );
          }

          if (state is ApplicationFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Erreur: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadMyApplications,
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          return _buildEmptyState();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_ind, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Aucune candidature',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vous n\'avez pas encore postulé à des offres d\'emploi.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationCard(ApplicationModel application) {
    final status = application.status;
    final statusColor = _getStatusColor(status);
    final statusLabel = _getStatusLabel(status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () => _showApplicationDetails(application),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          application.jobTitle ?? 'Offre d\'emploi',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          application.companyName ?? 'Entreprise inconnue',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDate(application.appliedAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  Text(
                    'Candidature envoyée',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ],
              ),
              if (application.coverLetter?.isNotEmpty == true) ...[
                const SizedBox(height: 12),
                Text(
                  application.coverLetter!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    return ApplicationStatusHelper.getStatusColor(status);
  }

  String _getStatusLabel(String status) {
    return ApplicationStatusHelper.getStatusLabel(status);
  }

  String _formatDate(dynamic date) {
    return DateFormatter.formatDate(date);
  }

  void _showApplicationDetails(ApplicationModel application) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Détails de la candidature',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Offre:', application.jobTitle ?? 'N/A'),
            _buildDetailRow('Entreprise:', application.companyName ?? 'N/A'),
            _buildDetailRow('Statut:', _getStatusLabel(application.status)),
            _buildDetailRow(
              'Date de candidature:',
              _formatDate(application.appliedAt),
            ),
            // Resume section - Show info even if resumePath is empty
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.description, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Mon Résumé',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (application.resumePath?.isNotEmpty == true) {
                      _viewResume(application.resumePath!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Aucun CV téléchargé')),
                      );
                    }
                  },
                  icon: const Icon(Icons.open_in_new, size: 14),
                  label: const Text('Voir'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                  ),
                ),
              ],
            ),
            if (application.coverLetter?.isNotEmpty == true) ...[
              const SizedBox(height: 12),
              const Text(
                'Lettre de motivation:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(application.coverLetter!),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fermer'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return DetailRow(label: label, value: value);
  }

  Future<void> _viewResume(String resumePath) async {
    if (resumePath.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aucun résumé disponible')),
        );
      }
      return;
    }

    final success = await FileOpener.openFile(resumePath);
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d\'ouvrir le résumé')),
      );
    }
  }
}
