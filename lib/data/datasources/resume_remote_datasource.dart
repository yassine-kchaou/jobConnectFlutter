import 'package:jobconnect/core/config/api_client.dart';
import 'package:jobconnect/core/constants/api_constants.dart';
import 'package:jobconnect/data/models/resume_model.dart';

abstract class ResumeRemoteDataSource {
  Future<ResumeModel> createResume(Map<String, dynamic> resumeData);
  Future<ResumeModel> getResumeById(String resumeId);
  Future<List<ResumeModel>> getResumesByUserId(String userId);
  Future<ResumeModel> updateResume(
      String resumeId, Map<String, dynamic> resumeData);
  Future<void> deleteResume(String resumeId);
  Future<ResumeModel> addEducation(
      String resumeId, Map<String, dynamic> educationData);
  Future<ResumeModel> addExperience(
      String resumeId, Map<String, dynamic> experienceData);
  Future<ResumeModel> addSkill(String resumeId, String skillName);
  Future<ResumeModel> addLanguage(
      String resumeId, Map<String, dynamic> languageData);
  Future<ResumeModel> addCertification(
      String resumeId, Map<String, dynamic> certificationData);
}

class ResumeRemoteDataSourceImpl implements ResumeRemoteDataSource {
  final ApiClient apiClient;

  ResumeRemoteDataSourceImpl({required this.apiClient});

  Map<String, dynamic> _ensureMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return {};
  }

  @override
  Future<ResumeModel> createResume(Map<String, dynamic> resumeData) async {
    try {
      print('📄 [ResumeRemote] Creating resume');
      final response = await apiClient.post(
        ApiConstants.resumesEndpoint,
        data: resumeData,
      );
      print('📄 [ResumeRemote] Resume created successfully');
      return ResumeModel.fromJson(_ensureMap(response.data));
    } catch (e) {
      print('❌ [ResumeRemote] Create error: $e');
      rethrow;
    }
  }

  @override
  Future<ResumeModel> getResumeById(String resumeId) async {
    try {
      print('📄 [ResumeRemote] Fetching resume by ID: $resumeId');
      final response = await apiClient.get(
        '${ApiConstants.resumeByIdEndpoint}/$resumeId',
      );
      print('📄 [ResumeRemote] Response data: ${response.data}');
      final resumeModel = ResumeModel.fromJson(_ensureMap(response.data));
      print('✅ [ResumeRemote] Resume parsed:');
      print('   - ID: ${resumeModel.id}');
      print('   - Title: ${resumeModel.title}');
      print('   - Education count: ${resumeModel.educations?.length ?? 0}');
      print(
          '   - Experience count: ${resumeModel.workExperiences?.length ?? 0}');
      return resumeModel;
    } catch (e) {
      print('❌ [ResumeRemote] Fetch error: $e');
      rethrow;
    }
  }

  @override
  Future<List<ResumeModel>> getResumesByUserId(String userId) async {
    try {
      print('📄 [ResumeRemote] Fetching resumes for user: $userId');
      final response = await apiClient.get(
        '${ApiConstants.resumesByUserEndpoint}/$userId',
      );

      List<dynamic> resumes = [];

      // Handle different response formats
      if (response.data is List) {
        resumes = response.data;
      } else if (response.data is Map) {
        // If it's a single resume object (not a list), wrap it in a list
        if (response.data.containsKey('_id') ||
            response.data.containsKey('userId')) {
          resumes = [response.data];
        } else if (response.data['resumes'] is List) {
          resumes = response.data['resumes'];
        } else if (response.data['data'] is List) {
          resumes = response.data['data'];
        }
      }

      print('📄 [ResumeRemote] Found ${resumes.length} resumes');
      return resumes.map((r) => ResumeModel.fromJson(_ensureMap(r))).toList();
    } catch (e) {
      print('❌ [ResumeRemote] Fetch by user error: $e');
      rethrow;
    }
  }

  @override
  Future<ResumeModel> updateResume(
      String resumeId, Map<String, dynamic> resumeData) async {
    try {
      print('📄 [ResumeRemote] Updating resume: $resumeId');
      final response = await apiClient.put(
        '${ApiConstants.resumeByIdEndpoint}/$resumeId',
        data: resumeData,
      );
      print('📄 [ResumeRemote] Resume updated successfully');
      return ResumeModel.fromJson(_ensureMap(response.data));
    } catch (e) {
      print('❌ [ResumeRemote] Update error: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteResume(String resumeId) async {
    try {
      print('📄 [ResumeRemote] Deleting resume: $resumeId');
      final response = await apiClient.delete(
        '${ApiConstants.resumeByIdEndpoint}/$resumeId',
      );
      print('📄 [ResumeRemote] Resume deleted successfully');
      print('📄 [ResumeRemote] Delete response: $response');
    } catch (e) {
      print('❌ [ResumeRemote] Delete error: $e');
      rethrow;
    }
  }

  @override
  Future<ResumeModel> addEducation(
      String resumeId, Map<String, dynamic> educationData) async {
    try {
      print('📄 [ResumeRemote] Adding education to resume: $resumeId');
      // TODO: Backend endpoint not yet implemented
      throw UnimplementedError(
          'addEducation endpoint not available in backend');
      // final response = await apiClient.post(
      //   '${ApiConstants.resumeByIdEndpoint}/$resumeId/education',
      //   data: educationData,
      // );
      // print('📄 [ResumeRemote] Education added successfully');
      // return ResumeModel.fromJson(_ensureMap(response.data));
    } catch (e) {
      print('❌ [ResumeRemote] Add education error: $e');
      rethrow;
    }
  }

  @override
  Future<ResumeModel> addExperience(
      String resumeId, Map<String, dynamic> experienceData) async {
    try {
      print('📄 [ResumeRemote] Adding experience to resume: $resumeId');
      // TODO: Backend endpoint not yet implemented
      throw UnimplementedError(
          'addExperience endpoint not available in backend');
      // final response = await apiClient.post(
      //   '${ApiConstants.resumeByIdEndpoint}/$resumeId/experience',
      //   data: experienceData,
      // );
      // print('📄 [ResumeRemote] Experience added successfully');
      // return ResumeModel.fromJson(_ensureMap(response.data));
    } catch (e) {
      print('❌ [ResumeRemote] Add experience error: $e');
      rethrow;
    }
  }

  @override
  Future<ResumeModel> addSkill(String resumeId, String skillName) async {
    try {
      print('📄 [ResumeRemote] Adding skill to resume: $resumeId');
      // TODO: Backend endpoint not yet implemented
      throw UnimplementedError('addSkill endpoint not available in backend');
      // final response = await apiClient.post(
      //   '${ApiConstants.resumeByIdEndpoint}/$resumeId/skill',
      //   data: {'name': skillName},
      // );
      // print('📄 [ResumeRemote] Skill added successfully');
      // return ResumeModel.fromJson(_ensureMap(response.data));
    } catch (e) {
      print('❌ [ResumeRemote] Add skill error: $e');
      rethrow;
    }
  }

  @override
  Future<ResumeModel> addLanguage(
      String resumeId, Map<String, dynamic> languageData) async {
    try {
      print('📄 [ResumeRemote] Adding language to resume: $resumeId');
      // TODO: Backend endpoint not yet implemented
      throw UnimplementedError('addLanguage endpoint not available in backend');
      // final response = await apiClient.post(
      //   '${ApiConstants.resumeByIdEndpoint}/$resumeId/language',
      //   data: languageData,
      // );
      // print('📄 [ResumeRemote] Language added successfully');
      // return ResumeModel.fromJson(_ensureMap(response.data));
    } catch (e) {
      print('❌ [ResumeRemote] Add language error: $e');
      rethrow;
    }
  }

  @override
  Future<ResumeModel> addCertification(
      String resumeId, Map<String, dynamic> certificationData) async {
    try {
      print('📄 [ResumeRemote] Adding certification to resume: $resumeId');
      // TODO: Backend endpoint not yet implemented
      throw UnimplementedError(
          'addCertification endpoint not available in backend');
      // final response = await apiClient.post(
      //   '${ApiConstants.resumeByIdEndpoint}/$resumeId/certification',
      //   data: certificationData,
      // );
      // print('📄 [ResumeRemote] Certification added successfully');
      // return ResumeModel.fromJson(_ensureMap(response.data));
    } catch (e) {
      print('❌ [ResumeRemote] Add certification error: $e');
      rethrow;
    }
  }
}
