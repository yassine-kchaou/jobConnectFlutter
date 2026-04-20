import 'package:dartz/dartz.dart';
import 'package:jobconnect/core/errors/failures.dart';
import 'package:jobconnect/data/datasources/application_remote_datasource.dart';
import 'package:jobconnect/data/models/application_model.dart';
import 'package:jobconnect/domain/repositories/application_repository.dart';

class ApplicationRepositoryImpl implements ApplicationRepository {
  final ApplicationRemoteDataSource remoteDataSource;

  ApplicationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ApplicationModel>>> getAllApplications() async {
    try {
      final applications = await remoteDataSource.getAllApplications();
      return Right(applications);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<ApplicationModel>>> getApplicationsByStatus(
      String status) async {
    try {
      final applications =
          await remoteDataSource.getApplicationsByStatus(status);
      return Right(applications);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, ApplicationModel>> applyForJob(
      Map<String, dynamic> applicationData) async {
    try {
      final application = await remoteDataSource.applyForJob(applicationData);
      return Right(application);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<ApplicationModel>>> getApplicationsByJobId(
      String jobId) async {
    try {
      final applications = await remoteDataSource.getApplicationsByJobId(jobId);
      return Right(applications);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<ApplicationModel>>> getApplicationsByApplicantId(
      String applicantId) async {
    try {
      final applications =
          await remoteDataSource.getApplicationsByApplicantId(applicantId);
      return Right(applications);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<ApplicationModel>>> getApplicationsByEntrepriseId(
      String entrepriseId) async {
    try {
      final applications =
          await remoteDataSource.getApplicationsByEntrepriseId(entrepriseId);
      return Right(applications);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, ApplicationModel>> getApplicationById(
      String applicationId) async {
    try {
      final application =
          await remoteDataSource.getApplicationById(applicationId);
      return Right(application);
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
