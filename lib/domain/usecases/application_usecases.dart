import 'package:dartz/dartz.dart';
import 'package:jobconnect/core/errors/failures.dart';
import 'package:jobconnect/data/models/application_model.dart';
import 'package:jobconnect/domain/repositories/application_repository.dart';

class GetAllApplicationsUseCase {
  final ApplicationRepository repository;
  GetAllApplicationsUseCase({required this.repository});

  Future<Either<Failure, List<ApplicationModel>>> call() {
    return repository.getAllApplications();
  }
}

class GetApplicationsByStatusUseCase {
  final ApplicationRepository repository;
  GetApplicationsByStatusUseCase({required this.repository});

  Future<Either<Failure, List<ApplicationModel>>> call(String status) {
    return repository.getApplicationsByStatus(status);
  }
}

class ApplyForJobUseCase {
  final ApplicationRepository repository;
  ApplyForJobUseCase({required this.repository});

  Future<Either<Failure, ApplicationModel>> call(
      Map<String, dynamic> applicationData) {
    return repository.applyForJob(applicationData);
  }
}

class GetApplicationsByJobIdUseCase {
  final ApplicationRepository repository;
  GetApplicationsByJobIdUseCase({required this.repository});

  Future<Either<Failure, List<ApplicationModel>>> call(String jobId) {
    return repository.getApplicationsByJobId(jobId);
  }
}

class GetApplicationsByApplicantIdUseCase {
  final ApplicationRepository repository;
  GetApplicationsByApplicantIdUseCase({required this.repository});

  Future<Either<Failure, List<ApplicationModel>>> call(String applicantId) {
    return repository.getApplicationsByApplicantId(applicantId);
  }
}

class GetApplicationsByEntrepriseIdUseCase {
  final ApplicationRepository repository;
  GetApplicationsByEntrepriseIdUseCase({required this.repository});

  Future<Either<Failure, List<ApplicationModel>>> call(String entrepriseId) {
    return repository.getApplicationsByEntrepriseId(entrepriseId);
  }
}

class GetApplicationByIdUseCase {
  final ApplicationRepository repository;
  GetApplicationByIdUseCase({required this.repository});

  Future<Either<Failure, ApplicationModel>> call(String applicationId) {
    return repository.getApplicationById(applicationId);
  }
}
