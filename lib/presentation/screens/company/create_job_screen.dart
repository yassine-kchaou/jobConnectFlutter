import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobconnect/presentation/bloc/job_bloc.dart';
import 'package:jobconnect/presentation/theme/app_theme.dart';
import 'create_job_form.dart';

/// Écran de création d'offre d'emploi
/// Responsabilité unique: Orchestration de l'écran
class CreateJobScreen extends StatefulWidget {
  const CreateJobScreen({Key? key}) : super(key: key);

  @override
  State<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {
  /// Afficher un message d'erreur
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Afficher un message de succès
  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Gérer le succès de la création d'offre
  void _handleSuccess() async {
    _showSuccess('Offre d\'emploi créée avec succès! 🎉');

    // Recharger toutes les offres après création
    if (mounted) {
      context.read<JobBloc>().add(const FetchAllJobsEvent());
    }

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  /// Gérer les erreurs
  void _handleError(String message) {
    _showError(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer une offre d\'emploi'),
        elevation: 0,
        backgroundColor: AppTheme.primaryBlue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CreateJobForm(
            onSuccess: _handleSuccess,
            onError: _handleError,
          ),
        ),
      ),
    );
  }
}
