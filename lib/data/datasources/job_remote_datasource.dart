import 'package:jobconnect/core/config/api_client.dart';
import 'package:jobconnect/core/constants/api_constants.dart';
import 'package:jobconnect/data/models/job_model.dart';

abstract class JobRemoteDataSource {
  Future<List<JobModel>> getAllJobs({int page = 1, int limit = 10});
  Future<JobModel> getJobById(String jobId);
  Future<List<JobModel>> getJobsByCity(String city);
  Future<List<JobModel>> getJobsByStartDate(String startDate);
  Future<List<JobModel>> getJobsByPriceAndType({
    required double minPrice,
    required double maxPrice,
    required String type,
  });
  Future<List<JobModel>> getJobsByUser(String userId);
  Future<JobModel> createJob({required Map<String, dynamic> jobData});
  Future<JobModel> updateJob({
    required String jobId,
    required Map<String, dynamic> jobData,
  });
  Future<void> deleteJob(String jobId);
}

class JobRemoteDataSourceImpl implements JobRemoteDataSource {
  final ApiClient apiClient;

  JobRemoteDataSourceImpl({required this.apiClient});

  // Helper: safely extract list from response
  List<dynamic> _extractJobsList(dynamic data) {
    if (data is List) return data;
    if (data is Map) {
      if (data['jobs'] is List) return data['jobs'];
      if (data['data'] is List) return data['data'];
    }
    return [];
  }

  // Helper: ensure Map<String, dynamic> for JobModel.fromJson
  Map<String, dynamic> _ensureMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return {};
  }

  @override
  Future<List<JobModel>> getAllJobs({int page = 1, int limit = 10}) async {
    try {
      print('🔵 [JobRemote] Fetching jobs - page: $page, limit: $limit');
      final response = await apiClient.get(
        ApiConstants.jobsEndpoint,
        queryParameters: {'page': page, 'limit': limit},
      );
      print('🟢 [JobRemote] Response status: ${response.statusCode}');
      print('🟢 [JobRemote] Response data: ${response.data}');

      final List<dynamic> jobs = _extractJobsList(response.data);
      print('🟢 [JobRemote] Extracted jobs count: ${jobs.length}');

      final result =
          jobs.map((job) => JobModel.fromJson(_ensureMap(job))).toList();
      print('🟢 [JobRemote] Parsed jobs count: ${result.length}');
      return result;
    } catch (e) {
      print('🔴 [JobRemote] Error: $e');
      rethrow;
    }
  }

  @override
  Future<JobModel> getJobById(String jobId) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.jobByIdEndpoint}/$jobId',
      );
      return JobModel.fromJson(_ensureMap(response.data));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<JobModel>> getJobsByCity(String city) async {
    try {
      print('🔵 [JobRemote] Fetching jobs by city: $city');
      final response = await apiClient.get(
        '${ApiConstants.jobByCityEndpoint}?city=$city',
      );
      print('🟢 [JobRemote] Response status: ${response.statusCode}');
      print('🟢 [JobRemote] Response data: ${response.data}');
      final List<dynamic> jobs = _extractJobsList(response.data);
      print('🟢 [JobRemote] Extracted jobs: ${jobs.length}');
      return jobs.map((job) => JobModel.fromJson(_ensureMap(job))).toList();
    } catch (e) {
      print('🔴 [JobRemote] Error fetching by city: $e');
      rethrow;
    }
  }

  @override
  Future<List<JobModel>> getJobsByStartDate(String startDate) async {
    try {
      print('🔵 [JobRemote] Fetching jobs by start date: $startDate');
      final response = await apiClient.get(
        '${ApiConstants.jobByStartDateEndpoint}?startDate=$startDate',
      );
      print('🟢 [JobRemote] Response status: ${response.statusCode}');
      print('🟢 [JobRemote] Response data: ${response.data}');
      final List<dynamic> jobs = _extractJobsList(response.data);
      print('🟢 [JobRemote] Extracted jobs: ${jobs.length}');
      return jobs.map((job) => JobModel.fromJson(_ensureMap(job))).toList();
    } catch (e) {
      print('🔴 [JobRemote] Error fetching by start date: $e');
      rethrow;
    }
  }

  @override
  Future<List<JobModel>> getJobsByPriceAndType({
    required double minPrice,
    required double maxPrice,
    required String type,
  }) async {
    try {
      print(
          '🔵 [JobRemote] Fetching jobs by price and type: $minPrice-$maxPrice, type: $type');
      final response = await apiClient.get(
        '${ApiConstants.jobByPriceAndTypeEndpoint}?minPrice=$minPrice&maxPrice=$maxPrice&pricingType=$type',
      );
      print('🟢 [JobRemote] Response status: ${response.statusCode}');
      print('🟢 [JobRemote] Response data: ${response.data}');
      final List<dynamic> jobs = _extractJobsList(response.data);
      print('🟢 [JobRemote] Extracted jobs: ${jobs.length}');
      return jobs.map((job) => JobModel.fromJson(_ensureMap(job))).toList();
    } catch (e) {
      print('🔴 [JobRemote] Error fetching by price and type: $e');
      rethrow;
    }
  }

  @override
  Future<List<JobModel>> getJobsByUser(String userId) async {
    try {
      print('🔵 [JobRemote] Fetching jobs by user: $userId');
      final response = await apiClient.get(
        '${ApiConstants.jobByUserEndpoint}?userID=$userId',
      );
      print('🟢 [JobRemote] Response status: ${response.statusCode}');
      print('🟢 [JobRemote] Response data: ${response.data}');
      final List<dynamic> jobs = _extractJobsList(response.data);
      print('🟢 [JobRemote] Extracted jobs: ${jobs.length}');
      return jobs.map((job) => JobModel.fromJson(_ensureMap(job))).toList();
    } catch (e) {
      print('🔴 [JobRemote] Error fetching by user: $e');
      rethrow;
    }
  }

  @override
  Future<JobModel> createJob({required Map<String, dynamic> jobData}) async {
    try {
      print('[JobDataSource] Creating job with data: $jobData');

      final response = await apiClient.post(
        ApiConstants.createJobEndpoint,
        data: jobData,
      );

      print(
          '[JobDataSource] Create job response status: ${response.statusCode}');
      print('[JobDataSource] Create job response data: ${response.data}');

      final createdJob = JobModel.fromJson(_ensureMap(response.data));
      print(
          '[JobDataSource] Job created successfully with id: ${createdJob.id}');

      return createdJob;
    } catch (e) {
      print('[JobDataSource] Error creating job: $e');
      rethrow;
    }
  }

  @override
  Future<JobModel> updateJob({
    required String jobId,
    required Map<String, dynamic> jobData,
  }) async {
    try {
      print('[JobDataSource] Updating job $jobId with data: $jobData');

      final response = await apiClient.put(
        '${ApiConstants.jobByIdEndpoint}/$jobId',
        data: jobData,
      );

      print(
          '[JobDataSource] Update job response status: ${response.statusCode}');
      print('[JobDataSource] Update job response data: ${response.data}');

      final updatedJob = JobModel.fromJson(_ensureMap(response.data));
      print('[JobDataSource] Job updated successfully: ${updatedJob.id}');

      return updatedJob;
    } catch (e) {
      print('[JobDataSource] Error updating job: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteJob(String jobId) async {
    try {
      print('[JobDataSource] Deleting job $jobId');

      // Essayer DELETE, mais si 404, on considère que c'est un succès
      // (soft delete côté client car backend ne supporte pas DELETE)
      try {
        final response = await apiClient.delete(
          '${ApiConstants.jobByIdEndpoint}/$jobId',
        );
        print(
            '[JobDataSource] Delete job response status: ${response.statusCode}');
        print('[JobDataSource] Job deleted successfully');
      } catch (e) {
        // Si 404, c'est que le backend ne supporte pas DELETE
        // On traite comme une suppression réussie (soft delete)
        if (e.toString().contains('404')) {
          print(
              '[JobDataSource] Backend does not support DELETE, treating as soft delete');
          return;
        }
        rethrow;
      }
    } catch (e) {
      print('[JobDataSource] Error deleting job: $e');
      rethrow;
    }
  }
}
