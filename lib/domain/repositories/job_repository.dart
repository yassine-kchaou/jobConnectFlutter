import 'package:dartz/dartz.dart';
import 'package:jobconnect/core/errors/failures.dart';
import 'package:jobconnect/domain/entities/job_entity.dart';

abstract class JobRepository {
  Future<Either<Failure, List<Job>>> getAllJobs({int page = 1, int limit = 10});
  Future<Either<Failure, Job>> getJobById(String jobId);
  Future<Either<Failure, List<Job>>> getJobsByCity(String city);
  Future<Either<Failure, List<Job>>> getJobsByStartDate(String startDate);
  Future<Either<Failure, List<Job>>> getJobsByPriceAndType({
    required double minPrice,
    required double maxPrice,
    required String type,
  });
  Future<Either<Failure, List<Job>>> getJobsByUser(String userId);
  Future<Either<Failure, Job>> createJob({
    required Map<String, dynamic> jobData,
  });
  Future<Either<Failure, Job>> updateJob({
    required String jobId,
    required Map<String, dynamic> jobData,
  });
  Future<Either<Failure, void>> deleteJob(String jobId);
}
