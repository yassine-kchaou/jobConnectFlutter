import 'package:flutter/material.dart';
import 'package:jobconnect/domain/entities/resume_entity.dart';
import 'package:jobconnect/presentation/theme/app_theme.dart';

/// Widget para exibir o CV de um candidato
/// Responsabilidade única: Renderizar seções do CV
class CandidateResumeView extends StatelessWidget {
  final Resume resume;
  final String candidateName;

  const CandidateResumeView({
    Key? key,
    required this.resume,
    required this.candidateName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Debug: Afficher les données du CV
    print('[CandidateResumeView] CV Data:');
    print('[CandidateResumeView] Title: ${resume.title}');
    print(
        '[CandidateResumeView] Education: ${resume.education?.length ?? 0} items');
    print(
        '[CandidateResumeView] Experience: ${resume.workExperience?.length ?? 0} items');
    print('[CandidateResumeView] Skills: ${resume.skills?.length ?? 0} items');
    print(
        '[CandidateResumeView] Languages: ${resume.languages?.length ?? 0} items');
    print(
        '[CandidateResumeView] Certifications: ${resume.certifications?.length ?? 0} items');

    // Vérifier si le CV est complètement vide
    final isEmpty = (resume.education == null || resume.education!.isEmpty) &&
        (resume.workExperience == null || resume.workExperience!.isEmpty) &&
        (resume.skills == null || resume.skills!.isEmpty) &&
        (resume.languages == null || resume.languages!.isEmpty) &&
        (resume.certifications == null || resume.certifications!.isEmpty) &&
        (resume.title == null || resume.title!.isEmpty) &&
        (resume.summary == null || resume.summary!.isEmpty);

    return Scaffold(
      appBar: AppBar(
        title: Text('CV - $candidateName'),
        backgroundColor: AppTheme.primaryBlue,
      ),
      body: isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.description,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'CV vide',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Le candidat n\'a pas encore rempli son CV',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Formações
                  if (resume.education != null && resume.education!.isNotEmpty)
                    _buildEducationSection(),
                  if (resume.education != null && resume.education!.isNotEmpty)
                    const SizedBox(height: 24),

                  // Experiências
                  if (resume.workExperience != null &&
                      resume.workExperience!.isNotEmpty)
                    _buildExperienceSection(),
                  if (resume.workExperience != null &&
                      resume.workExperience!.isNotEmpty)
                    const SizedBox(height: 24),

                  // Competências
                  if (resume.skills != null && resume.skills!.isNotEmpty)
                    _buildSkillsSection(),
                  if (resume.skills != null && resume.skills!.isNotEmpty)
                    const SizedBox(height: 24),

                  // Línguas
                  if (resume.languages != null && resume.languages!.isNotEmpty)
                    _buildLanguagesSection(),
                  if (resume.languages != null && resume.languages!.isNotEmpty)
                    const SizedBox(height: 24),

                  // Certificações
                  if (resume.certifications != null &&
                      resume.certifications!.isNotEmpty)
                    _buildCertificationsSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildEducationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📚 Formation',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...resume.education!.map((edu) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildItemCard(
              title: edu.institution,
              subtitle: '${edu.degree} ${edu.field}',
              date:
                  '${_formatDate(edu.startDate)} - ${_formatDate(edu.endDate)}',
            ),
          );
        }),
      ],
    );
  }

  Widget _buildExperienceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '💼 Expérience professionnelle',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...resume.workExperience!.map((exp) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildItemCard(
              title: exp.position,
              subtitle: exp.company,
              date: exp.endDate != null
                  ? '${_formatDate(exp.startDate)} - ${_formatDate(exp.endDate!)}'
                  : '${_formatDate(exp.startDate)} - Présent',
              description: exp.description,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🎯 Compétences',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: resume.skills!
              .map((skill) => Chip(
                    label: Text(skill.name),
                    backgroundColor:
                        AppTheme.primaryBlue.withValues(alpha: 0.1),
                    labelStyle: const TextStyle(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildLanguagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🌐 Langues',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...resume.languages!.map((lang) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildItemCard(
              title: lang.name,
              subtitle: lang.proficiency,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCertificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🏆 Certifications',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...resume.certifications!.map((cert) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildItemCard(
              title: cert.name,
              subtitle: cert.issuer,
              date: _formatDate(cert.issueDate),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildItemCard({
    required String title,
    String? subtitle,
    String? date,
    String? description,
  }) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
            ],
            if (date != null) ...[
              const SizedBox(height: 4),
              Text(
                date,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ],
            if (description != null && description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Formata data para formato legível
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day/$month/$year';
  }
}
