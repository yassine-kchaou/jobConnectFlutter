import 'package:equatable/equatable.dart';

class Resume extends Equatable {
  final String id;
  final String userId;
  final String? title;
  final String? summary;
  final List<Education>? education;
  final List<WorkExperience>? workExperience;
  final List<Skill>? skills;
  final List<Certification>? certifications;
  final List<Language>? languages;
  final String? pdfUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Resume({
    required this.id,
    required this.userId,
    this.title,
    this.summary,
    this.education,
    this.workExperience,
    this.skills,
    this.certifications,
    this.languages,
    this.pdfUrl,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        summary,
        education,
        workExperience,
        skills,
        certifications,
        languages,
        pdfUrl,
        createdAt,
        updatedAt,
      ];
}

class Education extends Equatable {
  final String id;
  final String institution;
  final String degree;
  final String field;
  final DateTime startDate;
  final DateTime endDate;

  const Education({
    required this.id,
    required this.institution,
    required this.degree,
    required this.field,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [
        id,
        institution,
        degree,
        field,
        startDate,
        endDate,
      ];
}

class WorkExperience extends Equatable {
  final String id;
  final String company;
  final String position;
  final String description;
  final DateTime startDate;
  final DateTime? endDate;

  const WorkExperience({
    required this.id,
    required this.company,
    required this.position,
    required this.description,
    required this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [
        id,
        company,
        position,
        description,
        startDate,
        endDate,
      ];
}

class Skill extends Equatable {
  final String id;
  final String name;
  final int level; // 1-5

  const Skill({required this.id, required this.name, required this.level});

  @override
  List<Object> get props => [id, name, level];
}

class Certification extends Equatable {
  final String id;
  final String name;
  final String issuer;
  final DateTime issueDate;
  final DateTime? expiryDate;

  const Certification({
    required this.id,
    required this.name,
    required this.issuer,
    required this.issueDate,
    this.expiryDate,
  });

  @override
  List<Object?> get props => [id, name, issuer, issueDate, expiryDate];
}

class Language extends Equatable {
  final String id;
  final String name;
  final String proficiency; // A1, A2, B1, B2, C1, C2

  const Language({
    required this.id,
    required this.name,
    required this.proficiency,
  });

  @override
  List<Object> get props => [id, name, proficiency];
}
