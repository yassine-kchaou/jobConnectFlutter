import 'package:dartz/dartz.dart';
import 'package:jobconnect/core/errors/failures.dart';
import 'package:jobconnect/data/datasources/resume_remote_datasource.dart';
import 'package:jobconnect/domain/entities/resume_entity.dart';
import 'package:jobconnect/domain/repositories/resume_repository.dart';

class ResumeRepositoryImpl implements ResumeRepository {
  final ResumeRemoteDataSource remoteDataSource;

  ResumeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Resume>> createResume(
      Map<String, dynamic> resumeData) async {
    try {
      final resume = await remoteDataSource.createResume(resumeData);
      return Right(resume.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, Resume>> getResumeById(String resumeId) async {
    try {
      final resume = await remoteDataSource.getResumeById(resumeId);
      return Right(resume.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<Resume>>> getResumesByUserId(
      String userId) async {
    try {
      final resumes = await remoteDataSource.getResumesByUserId(userId);
      return Right(resumes.map((r) => r.toEntity()).toList());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, Resume>> updateResume(
      String resumeId, Map<String, dynamic> resumeData) async {
    try {
      final resume = await remoteDataSource.updateResume(resumeId, resumeData);
      return Right(resume.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteResume(String resumeId) async {
    try {
      await remoteDataSource.deleteResume(resumeId);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, Resume>> addEducation(
      String resumeId, Map<String, dynamic> educationData) async {
    try {
      final resume =
          await remoteDataSource.addEducation(resumeId, educationData);
      return Right(resume.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, Resume>> addExperience(
      String resumeId, Map<String, dynamic> experienceData) async {
    try {
      final resume =
          await remoteDataSource.addExperience(resumeId, experienceData);
      return Right(resume.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, Resume>> addSkill(
      String resumeId, String skillName) async {
    try {
      final resume = await remoteDataSource.addSkill(resumeId, skillName);
      return Right(resume.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, Resume>> addLanguage(
      String resumeId, Map<String, dynamic> languageData) async {
    try {
      final resume = await remoteDataSource.addLanguage(resumeId, languageData);
      return Right(resume.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, Resume>> addCertification(
      String resumeId, Map<String, dynamic> certificationData) async {
    try {
      final resume =
          await remoteDataSource.addCertification(resumeId, certificationData);
      return Right(resume.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  Failure _handleException(dynamic e) {
    if (e is ServerFailure) {
      return e;
    }
    return UnknownFailure(message: e.toString());
  }
}
