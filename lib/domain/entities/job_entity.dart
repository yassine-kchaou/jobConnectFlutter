import 'package:equatable/equatable.dart';

class Job extends Equatable {
  final String id;
  final String title;
  final String description;
  final String company;
  final String? companyId;
  final String city;
  final String type; // fulltime, parttime, freelance
  final double salary;
  final DateTime startDate;
  final DateTime? endDate;
  final List<String>? requiredSkills;
  final int? applicants;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Job({
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

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    company,
    companyId,
    city,
    type,
    salary,
    startDate,
    endDate,
    requiredSkills,
    applicants,
    createdAt,
    updatedAt,
  ];
}
