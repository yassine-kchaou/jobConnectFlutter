import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobconnect/data/models/application_model.dart';
import 'package:jobconnect/domain/usecases/application_usecases.dart';

// Events
abstract class ApplicationEvent extends Equatable {
  const ApplicationEvent();
}

class FetchAllApplicationsEvent extends ApplicationEvent {
  const FetchAllApplicationsEvent();

  @override
  List<Object> get props => [];
}

class FetchApplicationsByStatusEvent extends ApplicationEvent {
  final String status;

  const FetchApplicationsByStatusEvent({required this.status});

  @override
  List<Object> get props => [status];
}

class ApplyForJobEvent extends ApplicationEvent {
  final Map<String, dynamic> applicationData;

  const ApplyForJobEvent({required this.applicationData});

  @override
  List<Object> get props => [applicationData];
}

class FetchApplicationsByJobIdEvent extends ApplicationEvent {
  final String jobId;

  const FetchApplicationsByJobIdEvent({required this.jobId});

  @override
  List<Object> get props => [jobId];
}

class FetchApplicationsByApplicantIdEvent extends ApplicationEvent {
  final String applicantId;

  const FetchApplicationsByApplicantIdEvent({required this.applicantId});

  @override
  List<Object> get props => [applicantId];
}

class FetchApplicationsByEntrepriseIdEvent extends ApplicationEvent {
  final String entrepriseId;

  const FetchApplicationsByEntrepriseIdEvent({required this.entrepriseId});

  @override
  List<Object> get props => [entrepriseId];
}

// States
abstract class ApplicationState extends Equatable {
  const ApplicationState();
}

class ApplicationInitial extends ApplicationState {
  const ApplicationInitial();

  @override
  List<Object> get props => [];
}

class ApplicationLoading extends ApplicationState {
  const ApplicationLoading();

  @override
  List<Object> get props => [];
}

class ApplicationsLoaded extends ApplicationState {
  final List<ApplicationModel> applications;

  const ApplicationsLoaded({required this.applications});

  @override
  List<Object> get props => [applications];
}

class ApplicationApplied extends ApplicationState {
  final ApplicationModel application;

  const ApplicationApplied({required this.application});

  @override
  List<Object> get props => [application];
}

class ApplicationFailure extends ApplicationState {
  final String message;

  const ApplicationFailure({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  final GetAllApplicationsUseCase getAllApplicationsUseCase;
  final GetApplicationsByStatusUseCase getApplicationsByStatusUseCase;
  final ApplyForJobUseCase applyForJobUseCase;
  final GetApplicationsByJobIdUseCase getApplicationsByJobIdUseCase;
  final GetApplicationsByApplicantIdUseCase getApplicationsByApplicantIdUseCase;
  final GetApplicationsByEntrepriseIdUseCase
      getApplicationsByEntrepriseIdUseCase;

  ApplicationBloc({
    required this.getAllApplicationsUseCase,
    required this.getApplicationsByStatusUseCase,
    required this.applyForJobUseCase,
    required this.getApplicationsByJobIdUseCase,
    required this.getApplicationsByApplicantIdUseCase,
    required this.getApplicationsByEntrepriseIdUseCase,
  }) : super(const ApplicationInitial()) {
    on<FetchAllApplicationsEvent>(_onFetchAllApplications);
    on<FetchApplicationsByStatusEvent>(_onFetchByStatus);
    on<ApplyForJobEvent>(_onApplyForJob);
    on<FetchApplicationsByJobIdEvent>(_onFetchByJobId);
    on<FetchApplicationsByApplicantIdEvent>(_onFetchByApplicantId);
    on<FetchApplicationsByEntrepriseIdEvent>(_onFetchByEntrepriseId);
  }

  Future<void> _onFetchAllApplications(
    FetchAllApplicationsEvent event,
    Emitter<ApplicationState> emit,
  ) async {
    emit(const ApplicationLoading());
    final result = await getAllApplicationsUseCase();
    result.fold(
      (failure) {
        print('❌ [ApplicationBloc] Error: ${failure.message}');
        emit(ApplicationFailure(message: failure.message));
      },
      (applications) {
        print('✅ [ApplicationBloc] Loaded ${applications.length} applications');
        emit(ApplicationsLoaded(applications: applications));
      },
    );
  }

  Future<void> _onFetchByStatus(
    FetchApplicationsByStatusEvent event,
    Emitter<ApplicationState> emit,
  ) async {
    emit(const ApplicationLoading());
    final result = await getApplicationsByStatusUseCase(event.status);
    result.fold(
      (failure) => emit(ApplicationFailure(message: failure.message)),
      (applications) => emit(ApplicationsLoaded(applications: applications)),
    );
  }

  Future<void> _onApplyForJob(
    ApplyForJobEvent event,
    Emitter<ApplicationState> emit,
  ) async {
    emit(const ApplicationLoading());
    print('📨 [ApplicationBloc] Applying for job...');
    final result = await applyForJobUseCase(event.applicationData);
    result.fold(
      (failure) {
        print('❌ [ApplicationBloc] Apply failed: ${failure.message}');
        emit(ApplicationFailure(message: failure.message));
      },
      (application) {
        print('✅ [ApplicationBloc] Application created successfully');
        emit(ApplicationApplied(application: application));
      },
    );
  }

  Future<void> _onFetchByJobId(
    FetchApplicationsByJobIdEvent event,
    Emitter<ApplicationState> emit,
  ) async {
    emit(const ApplicationLoading());
    final result = await getApplicationsByJobIdUseCase(event.jobId);
    result.fold(
      (failure) => emit(ApplicationFailure(message: failure.message)),
      (applications) => emit(ApplicationsLoaded(applications: applications)),
    );
  }

  Future<void> _onFetchByApplicantId(
    FetchApplicationsByApplicantIdEvent event,
    Emitter<ApplicationState> emit,
  ) async {
    emit(const ApplicationLoading());
    print(
        '📨 [ApplicationBloc] Fetching applications for applicant: ${event.applicantId}');
    final result = await getApplicationsByApplicantIdUseCase(event.applicantId);
    result.fold(
      (failure) {
        print('❌ [ApplicationBloc] Error: ${failure.message}');
        emit(ApplicationFailure(message: failure.message));
      },
      (applications) {
        print(
            '✅ [ApplicationBloc] Loaded ${applications.length} my applications');
        emit(ApplicationsLoaded(applications: applications));
      },
    );
  }

  Future<void> _onFetchByEntrepriseId(
    FetchApplicationsByEntrepriseIdEvent event,
    Emitter<ApplicationState> emit,
  ) async {
    emit(const ApplicationLoading());
    print(
        '📨 [ApplicationBloc] Fetching applications for company: ${event.entrepriseId}');
    final result =
        await getApplicationsByEntrepriseIdUseCase(event.entrepriseId);
    result.fold(
      (failure) {
        print('❌ [ApplicationBloc] Error: ${failure.message}');
        emit(ApplicationFailure(message: failure.message));
      },
      (applications) {
        print(
            '✅ [ApplicationBloc] Loaded ${applications.length} applications for company');
        emit(ApplicationsLoaded(applications: applications));
      },
    );
  }
}
