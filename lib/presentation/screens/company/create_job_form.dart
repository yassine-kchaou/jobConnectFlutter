import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobconnect/core/config/local_storage.dart';
import 'package:jobconnect/presentation/bloc/job_bloc.dart';
import 'package:jobconnect/presentation/theme/app_theme.dart';
import 'job_form_fields.dart';

/// Formulaire de création d'offre d'emploi
/// Responsabilité unique: Gestion du formulaire et soumission
class CreateJobForm extends StatefulWidget {
  final VoidCallback onSuccess;
  final Function(String) onError;

  const CreateJobForm({
    Key? key,
    required this.onSuccess,
    required this.onError,
  }) : super(key: key);

  @override
  State<CreateJobForm> createState() => _CreateJobFormState();
}

class _CreateJobFormState extends State<CreateJobForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _cityController;
  late TextEditingController _salaryController;
  late TextEditingController _skillsController;
  String _selectedType = 'fulltime';
  String _selectedPricingType = 'per day';
  DateTime? _selectedStartDate;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _cityController = TextEditingController();
    _salaryController = TextEditingController();
    _skillsController = TextEditingController();
    _selectedStartDate = DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _cityController.dispose();
    _salaryController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  /// Construire les données de l'offre à partir du formulaire
  /// Mappe les champs du formulaire frontend aux champs attendus par le backend
  Future<Map<String, dynamic>?> _buildJobData() async {
    try {
      final companyId = await LocalStorage().getUserId();

      if (companyId == null) {
        widget
            .onError('Erreur d\'authentification. Veuillez vous reconnecter.');
        return null;
      }

      final startDate = _selectedStartDate ?? DateTime.now();

      return {
        // Champs requis par le backend (job.schema.ts)
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'address': _cityController.text
            .trim(), // Backend utilise 'address', pas 'city'
        'startDate': startDate.toIso8601String(),
        'endDate': startDate
            .add(Duration(days: 30))
            .toIso8601String(), // Par défaut 30 jours après

        // Champs supplémentaires requis
        'startTime': '09:00', // Heure de début par défaut
        'endTime': '17:00', // Heure de fin par défaut
        'duration': '8 heures', // Durée de travail par défaut
        'contract':
            _selectedType == 'contract' ? 'CDI' : 'CDD', // Type de contrat
        'work_hours': 40, // Heures de travail par semaine par défaut
        'price': double.parse(_salaryController.text
            .trim()), // Backend utilise 'price', pas 'salary'
        'pricing_type': _selectedPricingType,

        // Métadonnées
        'entreprise_id':
            companyId, // Backend utilise 'entreprise_id', pas 'companyId'
        'applicants_ids': [], // Liste vide au départ
      };
    } catch (e) {
      widget.onError(
          'Erreur lors de la préparation des données: ${e.toString()}');
      return null;
    }
  }

  /// Soumettre le formulaire
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      print('📝 [CreateJobForm] Validating and submitting form...');
      print('📝 [CreateJobForm] Selected Pricing Type: $_selectedPricingType');

      final jobData = await _buildJobData();
      if (jobData == null) return;

      print('📝 [CreateJobForm] Job data prepared: $jobData');

      if (mounted) {
        context.read<JobBloc>().add(CreateJobEvent(jobData: jobData));
      }
    } catch (e) {
      print('❌ [CreateJobForm] Error during submission: $e');
      widget.onError('Erreur: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<JobBloc, JobState>(
      listener: (context, state) {
        if (state is JobCreated) {
          print('✅ [CreateJobForm] Job created successfully');
          widget.onSuccess();
        } else if (state is JobFailure) {
          print('❌ [CreateJobForm] Job creation failed: ${state.message}');
          widget.onError(state.message);
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Form Fields
            JobFormFields(
              titleController: _titleController,
              descriptionController: _descriptionController,
              cityController: _cityController,
              salaryController: _salaryController,
              skillsController: _skillsController,
              selectedType: _selectedType,
              selectedPricingType: _selectedPricingType,
              selectedStartDate: _selectedStartDate,
              onTypeChanged: (newType) {
                setState(() => _selectedType = newType);
              },
              onPricingTypeChanged: (newType) {
                setState(() => _selectedPricingType = newType);
              },
              onStartDateChanged: (newDate) {
                setState(() => _selectedStartDate = newDate);
              },
            ),
            const SizedBox(height: 32),

            // Submit Button
            _buildSubmitButton(context),
            const SizedBox(height: 16),

            // Info Text
            _buildInfoText(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return BlocBuilder<JobBloc, JobState>(
      builder: (context, state) {
        final isLoading = state is JobLoading;
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Créer l\'offre',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildInfoText(BuildContext context) {
    return Center(
      child: Text(
        '* Champs obligatoires',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[500],
            ),
      ),
    );
  }
}
