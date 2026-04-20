import 'package:dartz/dartz.dart';
import 'package:jobconnect/core/errors/failures.dart';
import 'package:jobconnect/domain/entities/resume_entity.dart';

abstract class ResumeRepository {
  Future<Either<Failure, Resume>> createResume(Map<String, dynamic> resumeData);
  Future<Either<Failure, Resume>> getResumeById(String resumeId);
  Future<Either<Failure, List<Resume>>> getResumesByUserId(String userId);
  Future<Either<Failure, Resume>> updateResume(
      String resumeId, Map<String, dynamic> resumeData);
  Future<Either<Failure, void>> deleteResume(String resumeId);
  Future<Either<Failure, Resume>> addEducation(
      String resumeId, Map<String, dynamic> educationData);
  Future<Either<Failure, Resume>> addExperience(
      String resumeId, Map<String, dynamic> experienceData);
  Future<Either<Failure, Resume>> addSkill(String resumeId, String skillName);
  Future<Either<Failure, Resume>> addLanguage(
      String resumeId, Map<String, dynamic> languageData);
  Future<Either<Failure, Resume>> addCertification(
      String resumeId, Map<String, dynamic> certificationData);
}
