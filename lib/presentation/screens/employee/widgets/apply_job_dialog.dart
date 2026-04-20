import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobconnect/core/config/local_storage.dart';
import 'package:jobconnect/data/models/job_model.dart';
import 'package:jobconnect/presentation/bloc/application_bloc.dart';
import 'package:jobconnect/presentation/bloc/auth_bloc.dart';
import 'package:jobconnect/presentation/bloc/resume_bloc.dart';
import 'package:jobconnect/presentation/theme/app_theme.dart';

class ApplyJobDialog extends StatefulWidget {
  final JobModel job;

  const ApplyJobDialog({
    Key? key,
    required this.job,
  }) : super(key: key);

  @override
  State<ApplyJobDialog> createState() => _ApplyJobDialogState();
}

class _ApplyJobDialogState extends State<ApplyJobDialog> {
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserResume();
  }

  Future<void> _loadUserResume() async {
    try {
      final userId = await LocalStorage().getUserId();
      if (userId != null && mounted) {
        context.read<ResumeBloc>().add(
              FetchResumesByUserIdEvent(userId: userId),
            );
      }
    } catch (e) {
      print('❌ Error loading resume: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _submit() {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthSuccess) {
      setState(() {
        _errorMessage = 'Utilisateur non authentifié';
      });
      return;
    }

    final userId = authState.user.id;
    final entrepriseId = widget.job.companyId; // Get company ID from job

    if (entrepriseId == null || entrepriseId.isEmpty) {
      setState(() {
        _errorMessage = 'Erreur: Entreprise non disponible';
      });
      return;
    }

    // Build application data with correct field names matching backend schema
    final applicationData = {
      'job_id': widget.job.id, // Backend uses snake_case
      'user_id': userId, // Backend uses snake_case
      'entreprise_id': entrepriseId, // Backend uses snake_case
      'status': 'pending', // Backend uses 'pending' not 'applied'
    };

    print('📨 Submitting application with data: $applicationData');

    context.read<ApplicationBloc>().add(
          ApplyForJobEvent(applicationData: applicationData),
        );

    setState(() => _isLoading = true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ApplicationBloc, ApplicationState>(
      listener: (context, state) {
        if (state is ApplicationApplied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Candidature envoyée avec succès!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.pop(context);
        } else if (state is ApplicationFailure) {
          setState(() {
            _isLoading = false;
            _errorMessage = state.message;
          });
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Postuler à l\'offre',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Job info
                Text(
                  widget.job.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.job.company,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),

                // Resume Section
                _buildResumeSection(),
                const SizedBox(height: 20),

                // Error message
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      border: Border.all(color: Colors.red[200]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 13,
                      ),
                    ),
                  ),
                if (_errorMessage != null) const SizedBox(height: 12),

                // Information about application
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                    border: Border.all(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'En cliquant sur "Postuler", vous allez confirmer votre candidature avec votre CV pour cette offre d\'emploi.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.primaryBlue,
                        ),
                  ),
                ),
                const SizedBox(height: 20),

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed:
                            _isLoading ? null : () => Navigator.pop(context),
                        child: const Text('Annuler'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text('Postuler'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResumeSection() {
    return BlocBuilder<ResumeBloc, ResumeState>(
      builder: (context, state) {
        if (state is ResumeLoading) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const SizedBox(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        if (state is ResumesLoaded && state.resumes.isNotEmpty) {
          final resume = state.resumes.first;
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              border: Border.all(color: Colors.green[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green[600]),
                    const SizedBox(width: 8),
                    const Text(
                      'Votre CV',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (resume.title?.isNotEmpty == true)
                  Text(
                    resume.title!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                if (resume.education != null && resume.education!.isNotEmpty)
                  Text(
                    '📚 ${resume.education!.length} formation(s)',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                if (resume.workExperience != null &&
                    resume.workExperience!.isNotEmpty)
                  Text(
                    '💼 ${resume.workExperience!.length} expérience(s)',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                if (resume.skills != null && resume.skills!.isNotEmpty)
                  Text(
                    '🎯 ${resume.skills!.length} compétence(s)',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
              ],
            ),
          );
        }

        if (state is ResumeFailure) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              border: Border.all(color: Colors.orange[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.warning, color: Colors.orange[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pas de CV détecté',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        'Veuillez créer un CV avant de postuler',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // No resume state
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Chargement du CV...',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }
}
