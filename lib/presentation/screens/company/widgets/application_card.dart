import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobconnect/data/models/application_model.dart';
import 'package:jobconnect/presentation/bloc/resume_bloc.dart';
import 'package:jobconnect/presentation/theme/app_theme.dart';
import 'candidate_resume_view.dart';

/// Widget pour afficher une candidature
/// Responsabilité unique: Affichage des données d'une candidature
class ApplicationCard extends StatelessWidget {
  final ApplicationModel application;

  const ApplicationCard({Key? key, required this.application})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract applicant info
    final candidateName = application.applicantName ?? 'Candidat inconnu';
    final candidateEmail = application.applicantEmail ?? 'Email non disponible';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nom du candidat
            Text(
              candidateName,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Email du candidat
            Row(
              children: [
                const Icon(Icons.email, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    candidateEmail,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Offre d'emploi
            if (application.jobTitle?.isNotEmpty == true) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.work, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      application.jobTitle!,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],

            // CV du candidat - Afficher le bouton avec chargement du CV
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.description, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'CV du candidat',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _viewCandidateResume(
                    context,
                    candidateName,
                    application.employeeId,
                  ),
                  icon: const Icon(Icons.open_in_new, size: 14),
                  label: const Text('Voir'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                  ),
                ),
              ],
            ),

            // Lettre de motivation si présente
            if (application.coverLetter?.isNotEmpty == true) ...[
              const SizedBox(height: 12),
              Text(
                'Lettre de motivation:',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                application.coverLetter!,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Charger et afficher le CV du candidat
  Future<void> _viewCandidateResume(
    BuildContext context,
    String candidateName,
    String employeeId,
  ) async {
    if (!context.mounted) return;

    // Afficher un dialog de chargement immédiatement
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Chargement du CV'),
        content: SizedBox(
          height: 100,
          child: Center(
            child: CircularProgressIndicator(color: AppTheme.primaryBlue),
          ),
        ),
      ),
    );

    // Attendre un bit pour que le dialog soit affiché
    await Future.delayed(const Duration(milliseconds: 100));

    // Utiliser FetchResumesByUserIdEvent au lieu de FetchResumeByIdEvent
    // car employeeId est l'ID de l'utilisateur, pas du CV
    if (!context.mounted) return;
    context.read<ResumeBloc>().add(
      FetchResumesByUserIdEvent(userId: employeeId),
    );

    // Écouter l'état du ResumeBloc
    var resumeBloc = context.read<ResumeBloc>();
    var completer = Completer<void>();

    late StreamSubscription subscription;
    subscription = resumeBloc.stream.listen((state) {
      if (state is ResumesLoaded) {
        subscription.cancel();
        completer.complete();
      } else if (state is ResumeFailure) {
        subscription.cancel();
        completer.complete();
      }
    });

    // Attendre le chargement
    await completer.future;

    if (!context.mounted) {
      subscription.cancel();
      return;
    }

    // Fermer le dialog
    Navigator.pop(context);

    if (!context.mounted) return;

    // Vérifier l'état final et naviguer
    var finalState = resumeBloc.state;
    if (finalState is ResumesLoaded && finalState.resumes.isNotEmpty) {
      if (!context.mounted) return;
      // Prendre le premier CV (il y en a généralement qu'un par utilisateur)
      final resume = finalState.resumes.first;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CandidateResumeView(resume: resume, candidateName: candidateName),
        ),
      );
    } else if (finalState is ResumeFailure) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${finalState.message}'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucun CV trouvé pour ce candidat'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}
