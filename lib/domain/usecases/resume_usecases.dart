import 'package:dartz/dartz.dart';
import 'package:jobconnect/core/errors/failures.dart';
import 'package:jobconnect/domain/entities/resume_entity.dart';
import 'package:jobconnect/domain/repositories/resume_repository.dart';

class CreateResumeUseCase {
  final ResumeRepository repository;
  CreateResumeUseCase({required this.repository});

  Future<Either<Failure, Resume>> call(Map<String, dynamic> resumeData) {
    return repository.createResume(resumeData);
  }
}

class GetResumeByIdUseCase {
  final ResumeRepository repository;
  GetResumeByIdUseCase({required this.repository});

  Future<Either<Failure, Resume>> call(String resumeId) {
    return repository.getResumeById(resumeId);
  }
}

class GetResumesByUserIdUseCase {
  final ResumeRepository repository;
  GetResumesByUserIdUseCase({required this.repository});

  Future<Either<Failure, List<Resume>>> call(String userId) {
    return repository.getResumesByUserId(userId);
  }
}

class UpdateResumeUseCase {
  final ResumeRepository repository;
  UpdateResumeUseCase({required this.repository});

  Future<Either<Failure, Resume>> call(
      String resumeId, Map<String, dynamic> resumeData) {
    return repository.updateResume(resumeId, resumeData);
  }
}

class DeleteResumeUseCase {
  final ResumeRepository repository;
  DeleteResumeUseCase({required this.repository});

  Future<Either<Failure, void>> call(String resumeId) {
    return repository.deleteResume(resumeId);
  }
}

class AddEducationUseCase {
  final ResumeRepository repository;

  AddEducationUseCase({required this.repository});

  Future<Either<Failure, Resume>> call(
      String resumeId, Map<String, dynamic> educationData) {
    return repository.addEducation(resumeId, educationData);
  }
}

class AddExperienceUseCase {
  final ResumeRepository repository;

  AddExperienceUseCase({required this.repository});

  Future<Either<Failure, Resume>> call(
      String resumeId, Map<String, dynamic> experienceData) {
    return repository.addExperience(resumeId, experienceData);
  }
}

class AddSkillUseCase {
  final ResumeRepository repository;

  AddSkillUseCase({required this.repository});

  Future<Either<Failure, Resume>> call(String resumeId, String skillName) {
    return repository.addSkill(resumeId, skillName);
  }
}

class AddLanguageUseCase {
  final ResumeRepository repository;

  AddLanguageUseCase({required this.repository});

  Future<Either<Failure, Resume>> call(
      String resumeId, Map<String, dynamic> languageData) {
    return repository.addLanguage(resumeId, languageData);
  }
}

class AddCertificationUseCase {
  final ResumeRepository repository;

  AddCertificationUseCase({required this.repository});

  Future<Either<Failure, Resume>> call(
      String resumeId, Map<String, dynamic> certificationData) {
    return repository.addCertification(resumeId, certificationData);
  }
}
