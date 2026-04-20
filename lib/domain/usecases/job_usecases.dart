import 'package:dartz/dartz.dart';
import 'package:jobconnect/core/errors/failures.dart';
import 'package:jobconnect/domain/entities/job_entity.dart';
import 'package:jobconnect/domain/repositories/job_repository.dart';

class GetAllJobsUseCase {
  final JobRepository repository;

  GetAllJobsUseCase({required this.repository});

  Future<Either<Failure, List<Job>>> call({int page = 1, int limit = 10}) {
    return repository.getAllJobs(page: page, limit: limit);
  }
}

class GetJobByIdUseCase {
  final JobRepository repository;

  GetJobByIdUseCase({required this.repository});

  Future<Either<Failure, Job>> call(String jobId) {
    return repository.getJobById(jobId);
  }
}

class GetJobsByCityUseCase {
  final JobRepository repository;

  GetJobsByCityUseCase({required this.repository});

  Future<Either<Failure, List<Job>>> call(String city) {
    return repository.getJobsByCity(city);
  }
}

class GetJobsByStartDateUseCase {
  final JobRepository repository;

  GetJobsByStartDateUseCase({required this.repository});

  Future<Either<Failure, List<Job>>> call(String startDate) {
    return repository.getJobsByStartDate(startDate);
  }
}

class GetJobsByPriceAndTypeUseCase {
  final JobRepository repository;

  GetJobsByPriceAndTypeUseCase({required this.repository});

  Future<Either<Failure, List<Job>>> call({
    required double minPrice,
    required double maxPrice,
    required String type,
  }) {
    return repository.getJobsByPriceAndType(
      minPrice: minPrice,
      maxPrice: maxPrice,
      type: type,
    );
  }
}

class GetJobsByUserUseCase {
  final JobRepository repository;

  GetJobsByUserUseCase({required this.repository});

  Future<Either<Failure, List<Job>>> call(String userId) {
    return repository.getJobsByUser(userId);
  }
}

class CreateJobUseCase {
  final JobRepository repository;

  CreateJobUseCase({required this.repository});

  Future<Either<Failure, Job>> call(Map<String, dynamic> jobData) {
    return repository.createJob(jobData: jobData);
  }
}

class UpdateJobUseCase {
  final JobRepository repository;

  UpdateJobUseCase({required this.repository});

  Future<Either<Failure, Job>> call(
      String jobId, Map<String, dynamic> jobData) {
    return repository.updateJob(jobId: jobId, jobData: jobData);
  }
}

class DeleteJobUseCase {
  final JobRepository repository;

  DeleteJobUseCase({required this.repository});

  Future<Either<Failure, void>> call(String jobId) {
    return repository.deleteJob(jobId);
  }
}
