import 'package:jobconnect/domain/entities/resume_entity.dart';

class ResumeModel {
  final String id;
  final String userId;
  final String? title;
  final String? summary;
  final List<WorkExperienceModel>? workExperiences;
  final List<EducationModel>? educations;
  final List<SkillModel>? skills;
  final List<CertificationModel>? certifications;
  final List<LanguageModel>? languages;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ResumeModel({
    required this.id,
    required this.userId,
    this.title,
    this.summary,
    this.workExperiences,
    this.educations,
    this.skills,
    this.certifications,
    this.languages,
    this.createdAt,
    this.updatedAt,
  });

  Resume toEntity() => Resume(
        id: id,
        userId: userId,
        title: title,
        summary: summary,
        education: educations?.map((e) => e.toEntity()).toList(),
        workExperience: workExperiences?.map((e) => e.toEntity()).toList(),
        skills: skills?.map((e) => e.toEntity()).toList(),
        certifications: certifications?.map((e) => e.toEntity()).toList(),
        languages: languages?.map((e) => e.toEntity()).toList(),
        pdfUrl: null,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  factory ResumeModel.fromJson(Map<String, dynamic> json) {
    // Helper to handle both ID arrays and full objects
    List<WorkExperienceModel>? _parseWorkExperiences(dynamic data) {
      if (data == null) return null;
      if (data is! List) return null;
      return data
          .where((e) => e is Map<String, dynamic>)
          .map((e) => WorkExperienceModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    List<EducationModel>? _parseEducations(dynamic data) {
      if (data == null) return null;
      if (data is! List) return null;
      return data
          .where((e) => e is Map<String, dynamic>)
          .map((e) => EducationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    List<SkillModel>? _parseSkills(dynamic data) {
      if (data == null) return null;
      if (data is! List) return null;
      return data
          .where((e) => e is Map<String, dynamic>)
          .map((e) => SkillModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    List<CertificationModel>? _parseCertifications(dynamic data) {
      if (data == null) return null;
      if (data is! List) return null;
      return data
          .where((e) => e is Map<String, dynamic>)
          .map((e) => CertificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    List<LanguageModel>? _parseLanguages(dynamic data) {
      if (data == null) return null;
      if (data is! List) return null;
      return data
          .where((e) => e is Map<String, dynamic>)
          .map((e) => LanguageModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return ResumeModel(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? json['user_id'] ?? '',
      title: json['title'],
      summary: json['summary'],
      workExperiences: _parseWorkExperiences(json['workExperiences']) ??
          _parseWorkExperiences(json['workExperience']),
      educations: _parseEducations(json['educations']) ??
          _parseEducations(json['education']),
      skills: _parseSkills(json['skills']),
      certifications: _parseCertifications(json['certifications']) ??
          _parseCertifications(json['certification']),
      languages: _parseLanguages(json['languages']) ??
          _parseLanguages(json['language']),
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'summary': summary,
      'workExperiences': workExperiences?.map((e) => e.toJson()).toList(),
      'educations': educations?.map((e) => e.toJson()).toList(),
      'skills': skills?.map((e) => e.toJson()).toList(),
      'certifications': certifications?.map((e) => e.toJson()).toList(),
      'languages': languages?.map((e) => e.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class WorkExperienceModel {
  final String? id;
  final String? company;
  final String? position;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;

  WorkExperienceModel({
    this.id,
    this.company,
    this.position,
    this.description,
    this.startDate,
    this.endDate,
  });

  WorkExperience toEntity() => WorkExperience(
        id: id ?? '',
        company: company ?? '',
        position: position ?? '',
        description: description ?? '',
        startDate: startDate ?? DateTime.now(),
        endDate: endDate,
      );

  factory WorkExperienceModel.fromJson(Map<String, dynamic> json) {
    return WorkExperienceModel(
      id: json['_id'] ?? json['id'],
      company: json['company'],
      position: json['position'] ?? json['jobTitle'] ?? json['job_title'],
      description: json['description'],
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'position': position,
      'description': description,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}

class EducationModel {
  final String? id;
  final String? institution;
  final String? degree;
  final String? field;
  final DateTime? startDate;
  final DateTime? endDate;

  EducationModel({
    this.id,
    this.institution,
    this.degree,
    this.field,
    this.startDate,
    this.endDate,
  });

  Education toEntity() => Education(
        id: id ?? '',
        institution: institution ?? '',
        degree: degree ?? '',
        field: field ?? '',
        startDate: startDate ?? DateTime.now(),
        endDate: endDate ?? DateTime.now(),
      );

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      id: json['_id'] ?? json['id'],
      institution: json['institution'] ?? json['school'],
      degree: json['degree'],
      field: json['field'],
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'institution': institution,
      'degree': degree,
      'field': field,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}

class SkillModel {
  final String? id;
  final String? name;
  final int? level; // 1-5

  SkillModel({
    this.id,
    this.name,
    this.level,
  });

  Skill toEntity() => Skill(
        id: id ?? '',
        name: name ?? '',
        level: level ?? 1,
      );

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      level: json['level'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'level': level,
    };
  }
}

class CertificationModel {
  final String? id;
  final String? name;
  final String? issuer;
  final DateTime? issueDate;
  final DateTime? expiryDate;

  CertificationModel({
    this.id,
    this.name,
    this.issuer,
    this.issueDate,
    this.expiryDate,
  });

  Certification toEntity() => Certification(
        id: id ?? '',
        name: name ?? '',
        issuer: issuer ?? '',
        issueDate: issueDate ?? DateTime.now(),
        expiryDate: expiryDate,
      );

  factory CertificationModel.fromJson(Map<String, dynamic> json) {
    return CertificationModel(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      issuer: json['issuer'],
      issueDate: json['issueDate'] != null
          ? DateTime.parse(json['issueDate'])
          : json['issuedDate'] != null
              ? DateTime.parse(json['issuedDate'])
              : null,
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'issuer': issuer,
      'issueDate': issueDate?.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
    };
  }
}

class LanguageModel {
  final String? id;
  final String? name;
  final String? proficiency; // A1, A2, B1, B2, C1, C2

  LanguageModel({
    this.id,
    this.name,
    this.proficiency,
  });

  Language toEntity() => Language(
        id: id ?? '',
        name: name ?? '',
        proficiency: proficiency ?? 'A1',
      );

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      proficiency: json['proficiency'] ?? json['level'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'proficiency': proficiency,
    };
  }
}
