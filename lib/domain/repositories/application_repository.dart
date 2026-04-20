import 'package:dartz/dartz.dart';
import 'package:jobconnect/core/errors/failures.dart';
import 'package:jobconnect/data/models/application_model.dart';

abstract class ApplicationRepository {
  Future<Either<Failure, List<ApplicationModel>>> getAllApplications();
  Future<Either<Failure, List<ApplicationModel>>> getApplicationsByStatus(
      String status);
  Future<Either<Failure, ApplicationModel>> applyForJob(
      Map<String, dynamic> applicationData);
  Future<Either<Failure, List<ApplicationModel>>> getApplicationsByJobId(
      String jobId);
  Future<Either<Failure, List<ApplicationModel>>> getApplicationsByApplicantId(
      String applicantId);
  Future<Either<Failure, List<ApplicationModel>>> getApplicationsByEntrepriseId(
      String entrepriseId);
  Future<Either<Failure, ApplicationModel>> getApplicationById(
      String applicationId);
}
