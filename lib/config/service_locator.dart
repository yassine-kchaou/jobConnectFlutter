import 'package:get_it/get_it.dart';
import 'package:jobconnect/core/config/api_client.dart';
import 'package:jobconnect/core/config/local_storage.dart';
import 'package:jobconnect/data/datasources/auth_remote_datasource.dart';
import 'package:jobconnect/data/datasources/job_remote_datasource.dart';
import 'package:jobconnect/data/datasources/application_remote_datasource.dart';
import 'package:jobconnect/data/datasources/resume_remote_datasource.dart';
import 'package:jobconnect/data/datasources/error_handler.dart';
import 'package:jobconnect/data/datasources/dio_error_handler.dart';
import 'package:jobconnect/data/repositories/auth_repository_impl.dart';
import 'package:jobconnect/data/repositories/job_repository_impl.dart';
import 'package:jobconnect/data/repositories/application_repository_impl.dart';
import 'package:jobconnect/data/repositories/resume_repository_impl.dart';
import 'package:jobconnect/domain/repositories/auth_repository.dart';
import 'package:jobconnect/domain/repositories/job_repository.dart';
import 'package:jobconnect/domain/repositories/application_repository.dart';
import 'package:jobconnect/domain/repositories/resume_repository.dart';
import 'package:jobconnect/domain/usecases/auth_usecases.dart';
import 'package:jobconnect/domain/usecases/job_usecases.dart';
import 'package:jobconnect/domain/usecases/application_usecases.dart';
import 'package:jobconnect/domain/usecases/resume_usecases.dart';
import 'package:jobconnect/presentation/bloc/auth_bloc.dart';
import 'package:jobconnect/presentation/bloc/job_bloc.dart';
import 'package:jobconnect/presentation/bloc/application_bloc.dart';
import 'package:jobconnect/presentation/bloc/resume_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Singletons - API Client, Local Storage, and Error Handler
  getIt.registerSingleton<ApiClient>(ApiClient());
  getIt.registerSingleton<LocalStorage>(LocalStorage());
  getIt.registerSingleton<ErrorHandler>(DioErrorHandler());

  // Remote Data Sources
  getIt.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(
      apiClient: getIt<ApiClient>(),
      errorHandler: getIt<ErrorHandler>(),
    ),
  );
  getIt.registerSingleton<JobRemoteDataSource>(
    JobRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );
  getIt.registerSingleton<ApplicationRemoteDataSource>(
    ApplicationRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );
  getIt.registerSingleton<ResumeRemoteDataSource>(
    ResumeRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  // Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(remoteDataSource: getIt<AuthRemoteDataSource>()),
  );
  getIt.registerSingleton<JobRepository>(
    JobRepositoryImpl(remoteDataSource: getIt<JobRemoteDataSource>()),
  );
  getIt.registerSingleton<ApplicationRepository>(
    ApplicationRepositoryImpl(
        remoteDataSource: getIt<ApplicationRemoteDataSource>()),
  );
  getIt.registerSingleton<ResumeRepository>(
    ResumeRepositoryImpl(remoteDataSource: getIt<ResumeRemoteDataSource>()),
  );

  // Use Cases
  getIt.registerSingleton<LoginUseCase>(
    LoginUseCase(repository: getIt<AuthRepository>()),
  );
  getIt.registerSingleton<SignupUseCase>(
    SignupUseCase(repository: getIt<AuthRepository>()),
  );
  getIt.registerSingleton<GetUserUseCase>(
    GetUserUseCase(repository: getIt<AuthRepository>()),
  );
  getIt.registerSingleton<UploadAvatarUseCase>(
    UploadAvatarUseCase(repository: getIt<AuthRepository>()),
  );
  getIt.registerSingleton<UploadIdentityPicUseCase>(
    UploadIdentityPicUseCase(repository: getIt<AuthRepository>()),
  );

  // Job Use Cases
  getIt.registerSingleton<GetAllJobsUseCase>(
    GetAllJobsUseCase(repository: getIt<JobRepository>()),
  );
  getIt.registerSingleton<GetJobByIdUseCase>(
    GetJobByIdUseCase(repository: getIt<JobRepository>()),
  );
  getIt.registerSingleton<GetJobsByCityUseCase>(
    GetJobsByCityUseCase(repository: getIt<JobRepository>()),
  );
  getIt.registerSingleton<GetJobsByStartDateUseCase>(
    GetJobsByStartDateUseCase(repository: getIt<JobRepository>()),
  );
  getIt.registerSingleton<GetJobsByPriceAndTypeUseCase>(
    GetJobsByPriceAndTypeUseCase(repository: getIt<JobRepository>()),
  );
  getIt.registerSingleton<GetJobsByUserUseCase>(
    GetJobsByUserUseCase(repository: getIt<JobRepository>()),
  );
  getIt.registerSingleton<CreateJobUseCase>(
    CreateJobUseCase(repository: getIt<JobRepository>()),
  );
  getIt.registerSingleton<UpdateJobUseCase>(
    UpdateJobUseCase(repository: getIt<JobRepository>()),
  );
  getIt.registerSingleton<DeleteJobUseCase>(
    DeleteJobUseCase(repository: getIt<JobRepository>()),
  );

  // Application Use Cases
  getIt.registerSingleton<GetAllApplicationsUseCase>(
    GetAllApplicationsUseCase(repository: getIt<ApplicationRepository>()),
  );
  getIt.registerSingleton<GetApplicationsByStatusUseCase>(
    GetApplicationsByStatusUseCase(repository: getIt<ApplicationRepository>()),
  );
  getIt.registerSingleton<ApplyForJobUseCase>(
    ApplyForJobUseCase(repository: getIt<ApplicationRepository>()),
  );
  getIt.registerSingleton<GetApplicationsByJobIdUseCase>(
    GetApplicationsByJobIdUseCase(repository: getIt<ApplicationRepository>()),
  );
  getIt.registerSingleton<GetApplicationsByApplicantIdUseCase>(
    GetApplicationsByApplicantIdUseCase(
        repository: getIt<ApplicationRepository>()),
  );
  getIt.registerSingleton<GetApplicationsByEntrepriseIdUseCase>(
    GetApplicationsByEntrepriseIdUseCase(
        repository: getIt<ApplicationRepository>()),
  );

  // Resume Use Cases
  getIt.registerSingleton<GetResumeByIdUseCase>(
    GetResumeByIdUseCase(repository: getIt<ResumeRepository>()),
  );
  getIt.registerSingleton<GetResumesByUserIdUseCase>(
    GetResumesByUserIdUseCase(repository: getIt<ResumeRepository>()),
  );
  getIt.registerSingleton<CreateResumeUseCase>(
    CreateResumeUseCase(repository: getIt<ResumeRepository>()),
  );
  getIt.registerSingleton<UpdateResumeUseCase>(
    UpdateResumeUseCase(repository: getIt<ResumeRepository>()),
  );
  getIt.registerSingleton<DeleteResumeUseCase>(
    DeleteResumeUseCase(repository: getIt<ResumeRepository>()),
  );
  getIt.registerSingleton<AddEducationUseCase>(
    AddEducationUseCase(repository: getIt<ResumeRepository>()),
  );
  getIt.registerSingleton<AddExperienceUseCase>(
    AddExperienceUseCase(repository: getIt<ResumeRepository>()),
  );
  getIt.registerSingleton<AddSkillUseCase>(
    AddSkillUseCase(repository: getIt<ResumeRepository>()),
  );
  getIt.registerSingleton<AddLanguageUseCase>(
    AddLanguageUseCase(repository: getIt<ResumeRepository>()),
  );
  getIt.registerSingleton<AddCertificationUseCase>(
    AddCertificationUseCase(repository: getIt<ResumeRepository>()),
  );

  // BLoCs
  getIt.registerSingleton<AuthBloc>(
    AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      signupUseCase: getIt<SignupUseCase>(),
      localStorage: getIt<LocalStorage>(),
    ),
  );
  getIt.registerSingleton<JobBloc>(
    JobBloc(
      getAllJobsUseCase: getIt<GetAllJobsUseCase>(),
      getJobByIdUseCase: getIt<GetJobByIdUseCase>(),
      getJobsByCityUseCase: getIt<GetJobsByCityUseCase>(),
      getJobsByPriceAndTypeUseCase: getIt<GetJobsByPriceAndTypeUseCase>(),
      createJobUseCase: getIt<CreateJobUseCase>(),
      updateJobUseCase: getIt<UpdateJobUseCase>(),
      deleteJobUseCase: getIt<DeleteJobUseCase>(),
    ),
  );
  getIt.registerSingleton<ApplicationBloc>(
    ApplicationBloc(
      getAllApplicationsUseCase: getIt<GetAllApplicationsUseCase>(),
      getApplicationsByStatusUseCase: getIt<GetApplicationsByStatusUseCase>(),
      applyForJobUseCase: getIt<ApplyForJobUseCase>(),
      getApplicationsByJobIdUseCase: getIt<GetApplicationsByJobIdUseCase>(),
      getApplicationsByApplicantIdUseCase:
          getIt<GetApplicationsByApplicantIdUseCase>(),
      getApplicationsByEntrepriseIdUseCase:
          getIt<GetApplicationsByEntrepriseIdUseCase>(),
    ),
  );
  getIt.registerSingleton<ResumeBloc>(
    ResumeBloc(
      getResumeByIdUseCase: getIt<GetResumeByIdUseCase>(),
      getResumesByUserIdUseCase: getIt<GetResumesByUserIdUseCase>(),
      createResumeUseCase: getIt<CreateResumeUseCase>(),
      updateResumeUseCase: getIt<UpdateResumeUseCase>(),
      deleteResumeUseCase: getIt<DeleteResumeUseCase>(),
      addEducationUseCase: getIt<AddEducationUseCase>(),
      addExperienceUseCase: getIt<AddExperienceUseCase>(),
      addSkillUseCase: getIt<AddSkillUseCase>(),
      addLanguageUseCase: getIt<AddLanguageUseCase>(),
      addCertificationUseCase: getIt<AddCertificationUseCase>(),
    ),
  );
}
