import 'package:equatable/equatable.dart';

class Application extends Equatable {
  final String id;
  final String jobId;
  final String employeeId;
  final String status; // applied, accepted, rejected
  final String? resumePath;
  final String? coverLetter;
  final DateTime appliedAt;
  final DateTime? respondedAt;

  const Application({
    required this.id,
    required this.jobId,
    required this.employeeId,
    required this.status,
    this.resumePath,
    this.coverLetter,
    required this.appliedAt,
    this.respondedAt,
  });

  @override
  List<Object?> get props => [
    id,
    jobId,
    employeeId,
    status,
    resumePath,
    coverLetter,
    appliedAt,
    respondedAt,
  ];
}
