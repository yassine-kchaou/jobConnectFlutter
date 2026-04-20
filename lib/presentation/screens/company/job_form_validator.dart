/// Validateur pour le formulaire de création d'offre d'emploi
/// Responsabilité unique: Validation des données de formulaire
class JobFormValidator {
  /// Valide le titre du poste
  static String? validateTitle(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Le titre du poste est obligatoire';
    }
    if (value!.length < 3) {
      return 'Le titre doit contenir au moins 3 caractères';
    }
    if (value.length > 100) {
      return 'Le titre ne doit pas dépasser 100 caractères';
    }
    return null;
  }

  /// Valide la description du poste
  static String? validateDescription(String? value) {
    if (value?.isEmpty ?? true) {
      return 'La description est obligatoire';
    }
    if (value!.length < 20) {
      return 'La description doit contenir au moins 20 caractères';
    }
    if (value.length > 2000) {
      return 'La description ne doit pas dépasser 2000 caractères';
    }
    return null;
  }

  /// Valide la ville
  static String? validateCity(String? value) {
    if (value?.isEmpty ?? true) {
      return 'La ville est obligatoire';
    }
    if (value!.length < 2) {
      return 'Veuillez entrer un nom de ville valide';
    }
    return null;
  }

  /// Valide le salaire
  static String? validateSalary(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Le salaire est obligatoire';
    }
    final salary = double.tryParse(value!);
    if (salary == null) {
      return 'Veuillez entrer un montant valide';
    }
    if (salary < 0) {
      return 'Le salaire doit être positif';
    }
    if (salary > 999999) {
      return 'Le salaire ne peut pas dépasser 999 999€';
    }
    return null;
  }

  /// Valide les compétences requises
  static String? validateSkills(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Veuillez entrer au moins une compétence';
    }
    final skills = value!.split(',').where((s) => s.trim().isNotEmpty).toList();
    if (skills.isEmpty) {
      return 'Veuillez entrer au moins une compétence';
    }
    if (skills.length > 20) {
      return 'Vous ne pouvez pas ajouter plus de 20 compétences';
    }
    return null;
  }

  /// Valide que tous les champs obligatoires sont remplis
  static bool validateAll({
    required String title,
    required String description,
    required String city,
    required String salary,
    required String skills,
  }) {
    return validateTitle(title) == null &&
        validateDescription(description) == null &&
        validateCity(city) == null &&
        validateSalary(salary) == null &&
        validateSkills(skills) == null;
  }
}
