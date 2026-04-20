import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:jobconnect/core/errors/failures.dart';
import 'package:jobconnect/data/datasources/job_remote_datasource.dart';
import 'package:jobconnect/domain/entities/job_entity.dart';
import 'package:jobconnect/domain/repositories/job_repository.dart';

class JobRepositoryImpl implements JobRepository {
  final JobRemoteDataSource remoteDataSource;

  JobRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Job>>> getAllJobs({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final jobModels = await remoteDataSource.getAllJobs(
        page: page,
        limit: limit,
      );
      return Right(jobModels.map((job) => job.toEntity()).toList());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, Job>> getJobById(String jobId) async {
    try {
      final jobModel = await remoteDataSource.getJobById(jobId);
      return Right(jobModel.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<Job>>> getJobsByCity(String city) async {
    try {
      final jobModels = await remoteDataSource.getJobsByCity(city);
      return Right(jobModels.map((job) => job.toEntity()).toList());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<Job>>> getJobsByStartDate(
    String startDate,
  ) async {
    try {
      final jobModels = await remoteDataSource.getJobsByStartDate(startDate);
      return Right(jobModels.map((job) => job.toEntity()).toList());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<Job>>> getJobsByPriceAndType({
    required double minPrice,
    required double maxPrice,
    required String type,
  }) async {
    try {
      final jobModels = await remoteDataSource.getJobsByPriceAndType(
        minPrice: minPrice,
        maxPrice: maxPrice,
        type: type,
      );
      return Right(jobModels.map((job) => job.toEntity()).toList());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<Job>>> getJobsByUser(String userId) async {
    try {
      final jobModels = await remoteDataSource.getJobsByUser(userId);
      return Right(jobModels.map((job) => job.toEntity()).toList());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, Job>> createJob({
    required Map<String, dynamic> jobData,
  }) async {
    try {
      print('[JobRepository] Creating job with data: $jobData');
      final jobModel = await remoteDataSource.createJob(jobData: jobData);
      print('[JobRepository] Job created successfully');
      return Right(jobModel.toEntity());
    } catch (e) {
      print('[JobRepository] Error creating job: $e');
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, Job>> updateJob({
    required String jobId,
    required Map<String, dynamic> jobData,
  }) async {
    try {
      print('[JobRepository] Updating job $jobId with data: $jobData');
      final jobModel = await remoteDataSource.updateJob(
        jobId: jobId,
        jobData: jobData,
      );
      print('[JobRepository] Job updated successfully');
      return Right(jobModel.toEntity());
    } catch (e) {
      print('[JobRepository] Error updating job: $e');
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteJob(String jobId) async {
    try {
      print('[JobRepository] Deleting job $jobId');
      await remoteDataSource.deleteJob(jobId);
      print('[JobRepository] Job deleted successfully');
      return const Right(null);
    } catch (e) {
      print('[JobRepository] Error deleting job: $e');
      return Left(_handleException(e));
    }
  }

  Failure _handleException(dynamic e) {
    if (e is DioException) {
      final statusCode = e.response?.statusCode ?? 0;
      final message = e.response?.data?['message'] ??
          e.response?.data?['error'] ??
          _getDioErrorMessage(e);

      print(
          '[JobRepository] DioException - Status: $statusCode, Message: $message');

      switch (statusCode) {
        case 400:
          return ServerFailure(message: message ?? 'Données invalides');
        case 401:
          return ServerFailure(message: message ?? 'Non authentifié');
        case 403:
          return ServerFailure(message: message ?? 'Non autorisé');
        case 404:
          return ServerFailure(message: message ?? 'Ressource non trouvée');
        case 500:
          return ServerFailure(message: message ?? 'Erreur serveur');
        default:
          return ServerFailure(message: message ?? 'Erreur: $statusCode');
      }
    }

    if (e is ServerFailure) {
      return e;
    }

    print('[JobRepository] Unknown error: ${e.toString()}');
    return UnknownFailure(message: e.toString());
  }

  String _getDioErrorMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Délai de connexion dépassé';
      case DioExceptionType.sendTimeout:
        return 'Délai d\'envoi dépassé';
      case DioExceptionType.receiveTimeout:
        return 'Délai de réception dépassé';
      case DioExceptionType.badResponse:
        return 'Réponse invalide du serveur';
      case DioExceptionType.cancel:
        return 'Requête annulée';
      case DioExceptionType.connectionError:
        return 'Erreur de connexion - Vérifiez votre connexion';
      case DioExceptionType.unknown:
        return 'Erreur inconnue';
      default:
        return 'Une erreur est survenue';
    }
  }
}
