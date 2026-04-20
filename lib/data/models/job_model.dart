import 'package:jobconnect/domain/entities/job_entity.dart';

extension JobEntityToModel on Job {
  /// Convert Job entity to JobModel
  JobModel toJobModel() => JobModel(
        id: id,
        title: title,
        description: description,
        company: company,
        companyId: companyId,
        city: city,
        type: type,
        salary: salary,
        startDate: startDate,
        endDate: endDate,
        requiredSkills: requiredSkills,
        applicants: applicants,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

class JobModel {
  final String id;
  final String title;
  final String description;
  final String company;
  final String? companyId;
  final String city;
  final String type;
  final double salary;
  final DateTime startDate;
  final DateTime? endDate;
  final List<String>? requiredSkills;
  final int? applicants;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  JobModel({
    required this.id,
    required this.title,
    required this.description,
    required this.company,
    this.companyId,
    required this.city,
    required this.type,
    required this.salary,
    required this.startDate,
    this.endDate,
    this.requiredSkills,
    this.applicants,
    this.createdAt,
    this.updatedAt,
  });

  Job toEntity() => Job(
        id: id,
        title: title,
        description: description,
        company: company,
        companyId: companyId,
        city: city,
        type: type,
        salary: salary,
        startDate: startDate,
        endDate: endDate,
        requiredSkills: requiredSkills,
        applicants: applicants,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      company: json['company'] ??
          json['address'] ??
          '', // Backend ne renvoie pas 'company', utilise 'address'
      companyId: json['companyId'] ??
          json['entreprise_id'], // Backend utilise 'entreprise_id'
      city: json['city'] ??
          json['address'] ??
          '', // Backend utilise 'address' au lieu de 'city'
      type: json['type'] ??
          json['pricing_type'] ??
          'fulltime', // Backend utilise 'pricing_type'
      salary: _parseDouble(json['salary'] ??
          json['price'] ??
          0), // Backend utilise 'price' au lieu de 'salary'
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now(),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      requiredSkills: json['requiredSkills'] != null
          ? List<String>.from(json['requiredSkills'] as List)
          : null,
      applicants: _parseInt(json['applicants']),
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'company': company,
      'companyId': companyId,
      'city': city,
      'type': type,
      'salary': salary,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'requiredSkills': requiredSkills,
      'applicants': applicants,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
