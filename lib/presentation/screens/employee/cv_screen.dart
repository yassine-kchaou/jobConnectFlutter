import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobconnect/core/config/local_storage.dart';
import 'package:jobconnect/presentation/bloc/resume_bloc.dart';
import 'package:jobconnect/presentation/theme/app_theme.dart';
import 'package:jobconnect/presentation/screens/employee/profile/edit_cv_screen.dart';
import 'package:jobconnect/presentation/screens/employee/profile/create_cv_screen.dart';

class CVScreen extends StatefulWidget {
  const CVScreen({Key? key}) : super(key: key);

  @override
  State<CVScreen> createState() => _CVScreenState();
}

class _CVScreenState extends State<CVScreen> {
  // Controllers for dialog inputs
  final _universityController = TextEditingController();
  final _degreeController = TextEditingController();
  final _graduationYearController = TextEditingController();
  final _companyController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _startYearController = TextEditingController();
  final _endYearController = TextEditingController();
  final _skillController = TextEditingController();
  final _languageController = TextEditingController();
  final _languageLevelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserResumes();
  }

  void _loadUserResumes() async {
    final userId = await LocalStorage().getUserId();
    if (userId != null && mounted) {
      context.read<ResumeBloc>().add(
            FetchResumesByUserIdEvent(userId: userId),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon CV'),
        backgroundColor: AppTheme.primaryBlue,
      ),
      body: BlocListener<ResumeBloc, ResumeState>(
        listener: (context, state) {
          // Handle ResumeCreated state
          if (state is ResumeCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('CV créé avec succès!'),
                backgroundColor: Colors.green,
              ),
            );
            // Reload the resumes list after a short delay
            Future.delayed(const Duration(milliseconds: 300), () {
              _loadUserResumes();
            });
          }

          // Handle ResumeUpdated state
          if (state is ResumeUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('CV mis à jour avec succès!'),
                backgroundColor: Colors.green,
              ),
            );
            _loadUserResumes();
          }

          // Handle ResumeDeleted state
          if (state is ResumeDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('CV supprimé avec succès!'),
                backgroundColor: Colors.green,
              ),
            );
            // Reload the resumes list after a delay to ensure backend processed the deletion
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
                _loadUserResumes();
              }
            });
          }

          // Handle ResumeFailure state
          if (state is ResumeFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erreur: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<ResumeBloc, ResumeState>(
          builder: (context, state) {
            if (state is ResumeLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ResumesLoaded) {
              // Only show the first resume (one CV per user)
              if (state.resumes.isEmpty) {
                return _buildNoResumeScreen();
              }

              // Display the single CV
              final resume = state.resumes.first;
              return _buildSingleResumeScreen(resume);
            }

            if (state is ResumeFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Erreur: ${state.message}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadUserResumes,
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              );
            }

            return _buildNoResumeScreen();
          },
        ),
      ),
    );
  }

  // Screen when no CV exists
  Widget _buildNoResumeScreen() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.file_present, size: 80, color: AppTheme.primaryBlue),
            const SizedBox(height: 24),
            const Text(
              'Créez votre premier CV',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Un CV complet avec votre formation, expérience, compétences, langues et certifications.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateCVScreen(),
                    ),
                  );
                  if (result == true) {
                    _loadUserResumes();
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Créer mon CV'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Screen showing the single CV
  Widget _buildSingleResumeScreen(dynamic resume) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // CV Title and Summary
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (resume.title?.isNotEmpty == true)
                  Text(
                    resume.title!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
                  )
                else
                  Text(
                    'Mon CV',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                if (resume.summary?.isNotEmpty == true) ...[
                  const SizedBox(height: 12),
                  Text(
                    resume.summary!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Education Section
        _buildEducationSection(resume),
        const SizedBox(height: 20),

        // Experience Section
        _buildExperienceSection(resume),
        const SizedBox(height: 20),

        // Skills Section
        _buildSkillsSection(resume),
        const SizedBox(height: 20),

        // Languages Section
        _buildLanguagesSection(resume),
        const SizedBox(height: 20),

        // Certifications Section
        if (resume.certifications != null && resume.certifications!.isNotEmpty)
          _buildCertificationsSection(resume),

        // Action Buttons
        const SizedBox(height: 20),
        _buildActionsSection(resume),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildEducationSection(resume) {
    final education = resume.education ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Formation',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        if (education.isEmpty)
          Text('Aucune formation', style: TextStyle(color: Colors.grey[600]))
        else
          ...education
              .map((edu) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          edu.institution ?? 'École inconnue',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '${edu.degree ?? ''} ${edu.field ?? ''}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ))
              .cast<Widget>()
              .toList(),
        const SizedBox(height: 12),
        _buildAddEducationButton(resume),
      ],
    );
  }

  Widget _buildExperienceSection(resume) {
    final experience = resume.workExperience ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Expérience professionnelle',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        if (experience.isEmpty)
          Text('Aucune expérience', style: TextStyle(color: Colors.grey[600]))
        else
          ...experience
              .map((exp) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exp.position ?? 'Poste inconnu',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          exp.company ?? 'Entreprise inconnue',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ))
              .cast<Widget>()
              .toList(),
        const SizedBox(height: 12),
        _buildAddExperienceButton(resume),
      ],
    );
  }

  Widget _buildSkillsSection(resume) {
    final skills = resume.skills ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Compétences',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        if (skills.isEmpty)
          Text('Aucune compétence', style: TextStyle(color: Colors.grey[600]))
        else
          Wrap(
            spacing: 8,
            children: skills
                .map((skill) => Chip(
                      label: Text(skill.name ?? 'Compétence'),
                    ))
                .cast<Widget>()
                .toList(),
          ),
        const SizedBox(height: 12),
        _buildAddSkillButton(resume),
      ],
    );
  }

  Widget _buildLanguagesSection(resume) {
    final languages = resume.languages ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Langues',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        if (languages.isEmpty)
          Text('Aucune langue', style: TextStyle(color: Colors.grey[600]))
        else
          ...languages
              .map((lang) => Text(
                    '${lang.name ?? 'Inconnue'} - ${lang.proficiency ?? ''}',
                  ))
              .cast<Widget>()
              .toList(),
        const SizedBox(height: 12),
        _buildAddLanguageButton(resume),
      ],
    );
  }

  Widget _buildCertificationsSection(resume) {
    final certifications = resume.certifications ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Certifications',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        if (certifications.isEmpty)
          Text('Aucune certification',
              style: TextStyle(color: Colors.grey[600]))
        else
          ...certifications
              .map((cert) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cert.name ?? 'Certification inconnue',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          cert.issuer ?? '',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ))
              .cast<Widget>()
              .toList(),
      ],
    );
  }

  Widget _buildActionsSection(resume) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditCVScreen(resume: resume),
              ),
            );
            if (result == true) {
              _loadUserResumes();
            }
          },
          icon: const Icon(Icons.edit),
          label: const Text('Modifier'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryBlue,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _deleteResume(resume.id),
          icon: const Icon(Icons.delete),
          label: const Text('Supprimer'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildAddEducationButton(resume) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showAddEducationDialog(resume.id),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter une formation'),
      ),
    );
  }

  Widget _buildAddExperienceButton(resume) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showAddExperienceDialog(resume.id),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter une expérience'),
      ),
    );
  }

  Widget _buildAddSkillButton(resume) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showAddSkillDialog(resume.id),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter une compétence'),
      ),
    );
  }

  Widget _buildAddLanguageButton(resume) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showAddLanguageDialog(resume.id),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter une langue'),
      ),
    );
  }

  void _deleteResume(String resumeId) {
    print('🗑️ [CVScreen] Delete requested for resume: $resumeId');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le CV'),
        content: const Text('Êtes-vous sûr de vouloir supprimer ce CV?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              print('🗑️ [CVScreen] Confirming deletion for resume: $resumeId');
              Navigator.pop(context);
              context.read<ResumeBloc>().add(
                    DeleteResumeEvent(resumeId: resumeId),
                  );
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _showAddEducationDialog(String resumeId) {
    _universityController.clear();
    _degreeController.clear();
    _graduationYearController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter une formation'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _universityController,
                decoration: const InputDecoration(
                  hintText: 'Université/École',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _degreeController,
                decoration: const InputDecoration(
                  hintText: 'Diplôme (ex: Licence Informatique)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _graduationYearController,
                decoration: const InputDecoration(
                  hintText: 'Année de graduation',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              context.read<ResumeBloc>().add(
                    AddEducationEvent(
                      resumeId: resumeId,
                      educationData: {
                        'school': _universityController.text,
                        'degree': _degreeController.text,
                        'graduationYear': _graduationYearController.text,
                      },
                    ),
                  );
              Navigator.pop(context);
              _loadUserResumes();
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _showAddExperienceDialog(String resumeId) {
    _companyController.clear();
    _jobTitleController.clear();
    _startYearController.clear();
    _endYearController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter une expérience'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _companyController,
                decoration: const InputDecoration(
                  hintText: 'Nom de l\'entreprise',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _jobTitleController,
                decoration: const InputDecoration(
                  hintText: 'Titre du poste',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _startYearController,
                decoration: const InputDecoration(
                  hintText: 'Année de début',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _endYearController,
                decoration: const InputDecoration(
                  hintText: 'Année de fin (laisser vide si actuel)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              context.read<ResumeBloc>().add(
                    AddExperienceEvent(
                      resumeId: resumeId,
                      experienceData: {
                        'company': _companyController.text,
                        'position': _jobTitleController.text,
                        'startYear': _startYearController.text,
                        'endYear': _endYearController.text,
                      },
                    ),
                  );
              Navigator.pop(context);
              _loadUserResumes();
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _showAddSkillDialog(String resumeId) {
    _skillController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter une compétence'),
        content: TextField(
          controller: _skillController,
          decoration: const InputDecoration(
            hintText: 'Nom de la compétence (ex: Flutter, Firebase)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              context.read<ResumeBloc>().add(
                    AddSkillEvent(
                      resumeId: resumeId,
                      skillName: _skillController.text,
                    ),
                  );
              Navigator.pop(context);
              _loadUserResumes();
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _showAddLanguageDialog(String resumeId) {
    _languageController.clear();
    _languageLevelController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter une langue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _languageController,
              decoration: const InputDecoration(
                hintText: 'Langue (ex: Anglais, Français)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _languageLevelController,
              decoration: const InputDecoration(
                hintText: 'Niveau (ex: Natif, Courant, Intermédiaire)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              context.read<ResumeBloc>().add(
                    AddLanguageEvent(
                      resumeId: resumeId,
                      languageData: {
                        'language': _languageController.text,
                        'level': _languageLevelController.text,
                      },
                    ),
                  );
              Navigator.pop(context);
              _loadUserResumes();
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _universityController.dispose();
    _degreeController.dispose();
    _graduationYearController.dispose();
    _companyController.dispose();
    _jobTitleController.dispose();
    _startYearController.dispose();
    _endYearController.dispose();
    _skillController.dispose();
    _languageController.dispose();
    _languageLevelController.dispose();
    super.dispose();
  }
}
