import 'package:flutter/material.dart';
import 'package:jobconnect/presentation/theme/app_theme.dart';

class SkillsScreen extends StatefulWidget {
  const SkillsScreen({Key? key}) : super(key: key);

  @override
  State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  final List<String> skills = [
    'Flutter',
    'Dart',
    'REST API',
    'Firebase',
    'Git',
  ];
  final TextEditingController skillController = TextEditingController();

  @override
  void dispose() {
    skillController.dispose();
    super.dispose();
  }

  void addSkill() {
    if (skillController.text.isNotEmpty) {
      setState(() {
        skills.add(skillController.text);
      });
      skillController.clear();
    }
  }

  void removeSkill(int index) {
    setState(() {
      skills.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes compétences'),
        backgroundColor: AppTheme.primaryBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Add Skill Section
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: skillController,
                    decoration: InputDecoration(
                      hintText: 'Ajouter une compétence',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: addSkill,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Skills List
            if (skills.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(Icons.star_outline,
                        size: 64, color: AppTheme.primaryBlue),
                    const SizedBox(height: 16),
                    const Text('Aucune compétence ajoutée'),
                  ],
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  skills.length,
                  (index) => Chip(
                    label: Text(skills[index]),
                    onDeleted: () => removeSkill(index),
                    backgroundColor:
                        AppTheme.primaryBlue.withValues(alpha: 0.2),
                    deleteIconColor: AppTheme.primaryBlue,
                  ),
                ),
              ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Compétences sauvegardées')),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Enregistrer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
