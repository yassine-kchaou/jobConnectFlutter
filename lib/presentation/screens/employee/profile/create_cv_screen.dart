import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobconnect/core/config/local_storage.dart';
import 'package:jobconnect/presentation/bloc/resume_bloc.dart';
import 'package:jobconnect/presentation/theme/app_theme.dart';

class CreateCVScreen extends StatefulWidget {
  const CreateCVScreen({Key? key}) : super(key: key);

  @override
  State<CreateCVScreen> createState() => _CreateCVScreenState();
}

class _CreateCVScreenState extends State<CreateCVScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Infos générales
  final _titleController = TextEditingController();
  final _summaryController = TextEditingController();

  // Formation
  final _institutionController = TextEditingController();
  final _degreeController = TextEditingController();
  final _fieldController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  List<Map<String, dynamic>> _educationList = [];

  // Expérience
  final _companyController = TextEditingController();
  final _positionController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _expStartDateController = TextEditingController();
  final _expEndDateController = TextEditingController();
  List<Map<String, dynamic>> _experienceList = [];

  // Compétences
  final _skillController = TextEditingController();
  final _skillLevelController = TextEditingController(text: '1');
  List<Map<String, dynamic>> _skillsList = [];

  // Langues
  final _languageController = TextEditingController();
  final _proficiencyController = TextEditingController(text: 'A1');
  List<Map<String, dynamic>> _languagesList = [];

  // Certifications
  final _certNameController = TextEditingController();
  final _certIssuerController = TextEditingController();
  final _certDateController = TextEditingController();
  List<Map<String, dynamic>> _certificationsList = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _summaryController.dispose();
    _institutionController.dispose();
    _degreeController.dispose();
    _fieldController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _companyController.dispose();
    _positionController.dispose();
    _descriptionController.dispose();
    _expStartDateController.dispose();
    _expEndDateController.dispose();
    _skillController.dispose();
    _skillLevelController.dispose();
    _languageController.dispose();
    _proficiencyController.dispose();
    _certNameController.dispose();
    _certIssuerController.dispose();
    _certDateController.dispose();
    super.dispose();
  }

  void _addEducation() {
    if (_institutionController.text.isEmpty || _degreeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir institution et diplôme'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _educationList.add({
        'schoolName': _institutionController.text,
        'degree': _degreeController.text,
        'graduationYear': int.tryParse(_endDateController.text.split('-')[0]) ??
            DateTime.now().year,
      });
    });

    _institutionController.clear();
    _degreeController.clear();
    _endDateController.clear();
  }

  void _addExperience() {
    if (_companyController.text.isEmpty || _positionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir entreprise et poste'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _experienceList.add({
        'jobTitle': _positionController.text,
        'company': _companyController.text,
        'description': _descriptionController.text,
        'startDate': _expStartDateController.text,
        'endDate': _expEndDateController.text,
      });
    });

    _companyController.clear();
    _positionController.clear();
    _descriptionController.clear();
    _expStartDateController.clear();
    _expEndDateController.clear();
  }

  void _addSkill() {
    if (_skillController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer une compétence'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _skillsList.add({
        'name': _skillController.text,
        'proficiency': _skillLevelController.text.isNotEmpty
            ? _skillLevelController.text
            : 'Intermédiaire',
      });
    });

    _skillController.clear();
    _skillLevelController.text = '1';
  }

  void _addLanguage() {
    if (_languageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer une langue'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _languagesList.add({
        'name': _languageController.text,
        'proficiency': _proficiencyController.text,
      });
    });

    _languageController.clear();
    _proficiencyController.text = 'A1';
  }

  void _addCertification() {
    if (_certNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer un nom de certification'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _certificationsList.add({
        'name': _certNameController.text,
        'issuer': _certIssuerController.text,
        'date': _certDateController.text,
        'credentialsLink': '',
      });
    });

    _certNameController.clear();
    _certIssuerController.clear();
    _certDateController.clear();
  }

  void _submitCV() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer un titre pour le CV'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userId = await LocalStorage().getUserId();

      if (userId == null || userId.isEmpty) {
        throw Exception('userId not found');
      }

      final resumeData = {
        'userId': userId,
        'title': _titleController.text,
        'summary': _summaryController.text,
        'education': _educationList,
        'workExperience': _experienceList,
        'skills': _skillsList,
        'languages': _languagesList,
        'certifications': _certificationsList,
      };

      print('📄 [CreateCV] Submitting: $resumeData');

      if (!mounted) return;

      context.read<ResumeBloc>().add(CreateResumeEvent(resumeData: resumeData));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un CV complet'),
        backgroundColor: AppTheme.primaryBlue,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Infos', icon: Icon(Icons.info)),
            Tab(text: 'Formation', icon: Icon(Icons.school)),
            Tab(text: 'Expérience', icon: Icon(Icons.work)),
            Tab(text: 'Compétences', icon: Icon(Icons.build)),
            Tab(text: 'Langues', icon: Icon(Icons.language)),
            Tab(text: 'Certifications', icon: Icon(Icons.card_membership)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInfoTab(),
          _buildEducationTab(),
          _buildExperienceTab(),
          _buildSkillsTab(),
          _buildLanguagesTab(),
          _buildCertificationsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _submitCV,
        backgroundColor: AppTheme.primaryBlue,
        icon: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.save),
        label: Text(_isLoading ? 'Enregistrement...' : 'Créer le CV'),
      ),
    );
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('Titre du CV *'),
          TextField(
            controller: _titleController,
            decoration: _buildInputDecoration('Ex: CV Développeur Senior'),
          ),
          const SizedBox(height: 20),
          _buildLabel('Résumé professionnel'),
          TextField(
            controller: _summaryController,
            maxLines: 4,
            decoration: _buildInputDecoration('Décrivez votre profil...'),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormSection(
            title: 'Ajouter une formation',
            children: [
              _buildLabel('Institution *'),
              TextField(
                controller: _institutionController,
                decoration: _buildInputDecoration('Université/École'),
              ),
              const SizedBox(height: 12),
              _buildLabel('Diplôme *'),
              TextField(
                controller: _degreeController,
                decoration: _buildInputDecoration('Licence, Master, etc.'),
              ),
              const SizedBox(height: 12),
              _buildLabel('Année de graduation'),
              InkWell(
                onTap: () => _selectDate(_endDateController),
                child: TextField(
                  controller: _endDateController,
                  enabled: false,
                  decoration: _buildInputDecoration('YYYY-MM-DD'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _addEducation,
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_educationList.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Formations ajoutées',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ..._educationList.asMap().entries.map((entry) {
                  int idx = entry.key;
                  var edu = entry.value;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(edu['schoolName']),
                      subtitle: Text(
                        '${edu['degree']} - ${edu['graduationYear']}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _educationList.removeAt(idx);
                          });
                        },
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildExperienceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormSection(
            title: 'Ajouter une expérience',
            children: [
              _buildLabel('Entreprise *'),
              TextField(
                controller: _companyController,
                decoration: _buildInputDecoration('Nom de l\'entreprise'),
              ),
              const SizedBox(height: 12),
              _buildLabel('Poste *'),
              TextField(
                controller: _positionController,
                decoration: _buildInputDecoration('Titre du poste'),
              ),
              const SizedBox(height: 12),
              _buildLabel('Description'),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: _buildInputDecoration('Tâches et réalisations'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Date début'),
                        InkWell(
                          onTap: () => _selectDate(_expStartDateController),
                          child: TextField(
                            controller: _expStartDateController,
                            enabled: false,
                            decoration: _buildInputDecoration('YYYY-MM-DD'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Date fin'),
                        InkWell(
                          onTap: () => _selectDate(_expEndDateController),
                          child: TextField(
                            controller: _expEndDateController,
                            enabled: false,
                            decoration: _buildInputDecoration('YYYY-MM-DD'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _addExperience,
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_experienceList.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Expériences ajoutées',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ..._experienceList.asMap().entries.map((entry) {
                  int idx = entry.key;
                  var exp = entry.value;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(exp['jobTitle']),
                      subtitle: Text(exp['company']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _experienceList.removeAt(idx);
                          });
                        },
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSkillsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormSection(
            title: 'Ajouter une compétence',
            children: [
              _buildLabel('Compétence *'),
              TextField(
                controller: _skillController,
                decoration: _buildInputDecoration('Flutter, JavaScript, etc.'),
              ),
              const SizedBox(height: 12),
              _buildLabel('Niveau (1-5)'),
              TextField(
                controller: _skillLevelController,
                keyboardType: TextInputType.number,
                decoration: _buildInputDecoration('1 = Débutant, 5 = Expert'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _addSkill,
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_skillsList.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Compétences ajoutées',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _skillsList.asMap().entries.map((entry) {
                    int idx = entry.key;
                    var skill = entry.value;
                    return Chip(
                      label: Text('${skill['name']} - ${skill['proficiency']}'),
                      onDeleted: () {
                        setState(() {
                          _skillsList.removeAt(idx);
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildLanguagesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormSection(
            title: 'Ajouter une langue',
            children: [
              _buildLabel('Langue *'),
              TextField(
                controller: _languageController,
                decoration: _buildInputDecoration('Français, Anglais, etc.'),
              ),
              const SizedBox(height: 12),
              _buildLabel('Niveau *'),
              DropdownButtonFormField<String>(
                initialValue: _proficiencyController.text,
                items: const [
                  DropdownMenuItem(value: 'A1', child: Text('A1 - Débutant')),
                  DropdownMenuItem(
                    value: 'A2',
                    child: Text('A2 - Élémentaire'),
                  ),
                  DropdownMenuItem(
                    value: 'B1',
                    child: Text('B1 - Intermédiaire'),
                  ),
                  DropdownMenuItem(value: 'B2', child: Text('B2 - Supérieur')),
                  DropdownMenuItem(value: 'C1', child: Text('C1 - Avancé')),
                  DropdownMenuItem(value: 'C2', child: Text('C2 - Bilingue')),
                ],
                onChanged: (value) {
                  _proficiencyController.text = value ?? 'A1';
                },
                decoration: _buildInputDecoration('Sélectionnez le niveau'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _addLanguage,
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_languagesList.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Langues ajoutées',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ..._languagesList.asMap().entries.map((entry) {
                  int idx = entry.key;
                  var lang = entry.value;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(lang['name']),
                      subtitle: Text('Niveau: ${lang['proficiency']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _languagesList.removeAt(idx);
                          });
                        },
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCertificationsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormSection(
            title: 'Ajouter une certification',
            children: [
              _buildLabel('Nom de la certification *'),
              TextField(
                controller: _certNameController,
                decoration: _buildInputDecoration('AWS, Google Cloud, etc.'),
              ),
              const SizedBox(height: 12),
              _buildLabel('Organisme'),
              TextField(
                controller: _certIssuerController,
                decoration: _buildInputDecoration('Organisateur'),
              ),
              const SizedBox(height: 12),
              _buildLabel('Date'),
              InkWell(
                onTap: () => _selectDate(_certDateController),
                child: TextField(
                  controller: _certDateController,
                  enabled: false,
                  decoration: _buildInputDecoration('YYYY-MM-DD'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _addCertification,
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_certificationsList.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Certifications ajoutées',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ..._certificationsList.asMap().entries.map((entry) {
                  int idx = entry.key;
                  var cert = entry.value;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(cert['name']),
                      subtitle: Text(cert['issuer'] ?? 'Pas d\'organisme'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _certificationsList.removeAt(idx);
                          });
                        },
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildFormSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}
