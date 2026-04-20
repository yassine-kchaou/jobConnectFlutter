import 'package:flutter/material.dart';
import 'package:jobconnect/presentation/theme/app_theme.dart';
import 'job_form_validator.dart';

/// Widget pour les champs du formulaire de création d'offre
/// Responsabilité unique: Rendu des champs du formulaire
class JobFormFields extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController cityController;
  final TextEditingController salaryController;
  final TextEditingController skillsController;
  final String selectedType;
  final String selectedPricingType;
  final DateTime? selectedStartDate;
  final Function(String) onTypeChanged;
  final Function(String) onPricingTypeChanged;
  final Function(DateTime) onStartDateChanged;

  const JobFormFields({
    Key? key,
    required this.titleController,
    required this.descriptionController,
    required this.cityController,
    required this.salaryController,
    required this.skillsController,
    required this.selectedType,
    required this.selectedPricingType,
    required this.selectedStartDate,
    required this.onTypeChanged,
    required this.onPricingTypeChanged,
    required this.onStartDateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        _buildSectionHeader(context),
        const Divider(),
        const SizedBox(height: 16),

        // Job Title
        _buildJobTitleField(),
        const SizedBox(height: 16),

        // Description
        _buildDescriptionField(),
        const SizedBox(height: 16),

        // City
        _buildCityField(),
        const SizedBox(height: 16),

        // Salary
        _buildSalaryField(),
        const SizedBox(height: 16),

        // Required Skills
        _buildSkillsField(),
        const SizedBox(height: 16),

        // Job Type
        _buildJobTypeField(context),
        const SizedBox(height: 16),

        // Pricing Type
        _buildPricingTypeField(context),
        const SizedBox(height: 16),

        // Start Date
        _buildStartDateField(context),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations de l\'offre',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Remplissez tous les champs pour créer votre offre d\'emploi',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobTitleField() {
    return TextFormField(
      controller: titleController,
      decoration: InputDecoration(
        labelText: 'Titre du poste *',
        prefixIcon: const Icon(Icons.work),
        hintText: 'Ex: Développeur Flutter',
      ),
      validator: (value) => JobFormValidator.validateTitle(value),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: descriptionController,
      decoration: InputDecoration(
        labelText: 'Description du poste *',
        prefixIcon: const Icon(Icons.description),
        hintText: 'Décrivez le rôle, les responsabilités...',
      ),
      maxLines: 5,
      validator: (value) => JobFormValidator.validateDescription(value),
    );
  }

  Widget _buildCityField() {
    return TextFormField(
      controller: cityController,
      decoration: InputDecoration(
        labelText: 'Ville *',
        prefixIcon: const Icon(Icons.location_on),
        hintText: 'Ex: Paris',
      ),
      validator: (value) => JobFormValidator.validateCity(value),
    );
  }

  Widget _buildSalaryField() {
    return TextFormField(
      controller: salaryController,
      decoration: InputDecoration(
        labelText: 'Salaire annuel (€) *',
        prefixIcon: const Icon(Icons.attach_money),
        hintText: '30000',
      ),
      keyboardType: TextInputType.number,
      validator: (value) => JobFormValidator.validateSalary(value),
    );
  }

  Widget _buildSkillsField() {
    return TextFormField(
      controller: skillsController,
      decoration: InputDecoration(
        labelText: 'Compétences requises (séparées par des virgules)',
        prefixIcon: const Icon(Icons.school),
        hintText: 'Ex: Flutter, Dart, Firebase',
      ),
      maxLines: 2,
      validator: (value) => JobFormValidator.validateSkills(value),
    );
  }

  Widget _buildJobTypeField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type de contrat *',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'fulltime', label: Text('CDI')),
            ButtonSegment(value: 'parttime', label: Text('CDD')),
            ButtonSegment(value: 'freelance', label: Text('Freelance')),
          ],
          selected: {selectedType},
          onSelectionChanged: (Set<String> newSelection) {
            onTypeChanged(newSelection.first);
          },
        ),
      ],
    );
  }

  Widget _buildPricingTypeField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type de rémunération *',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'per hour', label: Text('À l\'heure')),
              ButtonSegment(value: 'per day', label: Text('Par jour')),
            ],
            selected: {selectedPricingType},
            onSelectionChanged: (Set<String> newSelection) {
              print(
                  '[JobFormFields] Pricing type changed to: ${newSelection.first}');
              onPricingTypeChanged(newSelection.first);
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Valeur sélectionnée: $selectedPricingType',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildStartDateField(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('Date de début *'),
      trailing: Text(
        selectedStartDate?.toString().split(' ')[0] ?? 'Sélectionnez',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
      ),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedStartDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          onStartDateChanged(picked);
        }
      },
    );
  }
}
