import 'package:jobconnect/domain/entities/application_entity.dart';

class ApplicationModel {
  final String id;
  final String jobId;
  final String employeeId;
  final String status; // applied, accepted, rejected
  final String? resumePath;
  final String? coverLetter;
  final DateTime appliedAt;
  final DateTime? respondedAt;

  // Extra fields for UI convenience (not in domain entity)
  final String? applicantName;
  final String? applicantEmail;
  final String? jobTitle;
  final String? companyName;

  ApplicationModel({
    required this.id,
    required this.jobId,
    required this.employeeId,
    required this.status,
    this.resumePath,
    this.coverLetter,
    required this.appliedAt,
    this.respondedAt,
    this.applicantName,
    this.applicantEmail,
    this.jobTitle,
    this.companyName,
  });

  Application toEntity() => Application(
        id: id,
        jobId: jobId,
        employeeId: employeeId,
        status: status,
        resumePath: resumePath,
        coverLetter: coverLetter,
        appliedAt: appliedAt,
        respondedAt: respondedAt,
      );

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    // Extract application data (could be nested under 'application' key)
    final appData = json['application'] ?? json;

    print('[ApplicationModel.fromJson] Full JSON: $json');
    print('[ApplicationModel.fromJson] appData: $appData');

    // Extract job data to get title and company
    final jobData = json['job'] as Map<String, dynamic>? ?? {};
    final jobTitle = jobData['title'] ??
        jobData['jobTitle'] ??
        json['jobTitle'] ??
        json['job_title'];
    final companyName = jobData['company'] ??
        jobData['companyName'] ??
        json['companyName'] ??
        json['company_name'];

    // Extract resume and cover letter from multiple possible locations
    String? resumePath = appData['resumePath'] ??
        appData['resume_path'] ??
        json['resumePath'] ??
        json['resume_path'];

    String? coverLetter = appData['coverLetter'] ??
        appData['cover_letter'] ??
        json['coverLetter'] ??
        json['cover_letter'];

    print('[ApplicationModel.fromJson] resumePath: $resumePath');
    print('[ApplicationModel.fromJson] coverLetter: $coverLetter');

    return ApplicationModel(
      id: json['_id'] ?? json['id'] ?? appData['_id'] ?? '',
      jobId: appData['jobId'] ?? appData['job_id'] ?? '',
      employeeId: appData['employeeId'] ??
          appData['employee_id'] ??
          appData['applicantId'] ??
          appData['applicant_id'] ??
          appData['user_id'] ??
          json['user_id'] ??
          '',
      status: appData['status'] ?? 'pending',
      resumePath: resumePath,
      coverLetter: coverLetter,
      appliedAt: appData['appliedAt'] != null
          ? DateTime.parse(appData['appliedAt'].toString())
          : (appData['applied_at'] != null
              ? DateTime.parse(appData['applied_at'].toString())
              : DateTime.now()),
      respondedAt: appData['respondedAt'] != null
          ? DateTime.parse(appData['respondedAt'].toString())
          : (appData['responded_at'] != null
              ? DateTime.parse(appData['responded_at'].toString())
              : null),
      // Extra UI fields - extract from nested job object or direct fields
      applicantName: json['applicantName'] ??
          json['applicant_name'] ??
          (json['applicant'] is Map
              ? (json['applicant'] as Map)['name']
              : null),
      applicantEmail: json['applicantEmail'] ??
          json['applicant_email'] ??
          (json['applicant'] is Map
              ? (json['applicant'] as Map)['email']
              : null),
      jobTitle: jobTitle,
      companyName: companyName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobId': jobId,
      'employeeId': employeeId,
      'status': status,
      'resumePath': resumePath,
      'coverLetter': coverLetter,
      'appliedAt': appliedAt.toIso8601String(),
      'respondedAt': respondedAt?.toIso8601String(),
      'applicantName': applicantName,
      'applicantEmail': applicantEmail,
      'jobTitle': jobTitle,
      'companyName': companyName,
    };
  }
}
