import 'package:jobconnect/core/config/api_client.dart';
import 'package:jobconnect/core/constants/api_constants.dart';
import 'package:jobconnect/data/models/application_model.dart';

abstract class ApplicationRemoteDataSource {
  Future<List<ApplicationModel>> getAllApplications();
  Future<List<ApplicationModel>> getApplicationsByStatus(String status);
  Future<ApplicationModel> applyForJob(Map<String, dynamic> applicationData);
  Future<List<ApplicationModel>> getApplicationsByJobId(String jobId);
  Future<List<ApplicationModel>> getApplicationsByApplicantId(
      String applicantId);
  Future<List<ApplicationModel>> getApplicationsByEntrepriseId(
      String entrepriseId);
  Future<ApplicationModel> getApplicationById(String applicationId);
}

class ApplicationRemoteDataSourceImpl implements ApplicationRemoteDataSource {
  final ApiClient apiClient;

  ApplicationRemoteDataSourceImpl({required this.apiClient});

  List<dynamic> _extractApplicationsList(dynamic data) {
    if (data is List) return data;
    if (data is Map) {
      if (data['applications'] is List) return data['applications'];
      if (data['data'] is List) return data['data'];
    }
    return [];
  }

  Map<String, dynamic> _ensureMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return {};
  }

  @override
  Future<List<ApplicationModel>> getAllApplications() async {
    try {
      print('📨 [ApplicationRemote] Fetching all applications');
      final response = await apiClient.get(ApiConstants.applicationsEndpoint);
      final List<dynamic> apps = _extractApplicationsList(response.data);
      print('📨 [ApplicationRemote] Found ${apps.length} applications');
      return apps
          .map((app) => ApplicationModel.fromJson(_ensureMap(app)))
          .toList();
    } catch (e) {
      print('❌ [ApplicationRemote] Error: $e');
      rethrow;
    }
  }

  @override
  Future<List<ApplicationModel>> getApplicationsByStatus(String status) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.applicationsByStatusEndpoint}/$status',
      );
      final List<dynamic> apps = _extractApplicationsList(response.data);
      return apps
          .map((app) => ApplicationModel.fromJson(_ensureMap(app)))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApplicationModel> applyForJob(
      Map<String, dynamic> applicationData) async {
    try {
      print('📨 [ApplicationRemote] Applying for job');
      final response = await apiClient.post(
        ApiConstants.applicationsEndpoint,
        data: applicationData,
      );
      print('📨 [ApplicationRemote] Applied successfully');
      return ApplicationModel.fromJson(_ensureMap(response.data));
    } catch (e) {
      print('❌ [ApplicationRemote] Apply error: $e');
      rethrow;
    }
  }

  @override
  Future<List<ApplicationModel>> getApplicationsByJobId(String jobId) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.applicationsByJobEndpoint}/$jobId',
      );
      final List<dynamic> apps = _extractApplicationsList(response.data);
      return apps
          .map((app) => ApplicationModel.fromJson(_ensureMap(app)))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ApplicationModel>> getApplicationsByApplicantId(
      String applicantId) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.applicationsByApplicantEndpoint}/$applicantId',
      );
      final List<dynamic> apps = _extractApplicationsList(response.data);
      return apps
          .map((app) => ApplicationModel.fromJson(_ensureMap(app)))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ApplicationModel>> getApplicationsByEntrepriseId(
      String entrepriseId) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.applicationsByEntrepriseEndpoint}/$entrepriseId',
      );
      final List<dynamic> apps = _extractApplicationsList(response.data);
      return apps
          .map((app) => ApplicationModel.fromJson(_ensureMap(app)))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApplicationModel> getApplicationById(String applicationId) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.applicationsEndpoint}/$applicationId',
      );
      return ApplicationModel.fromJson(_ensureMap(response.data));
    } catch (e) {
      rethrow;
    }
  }
}
