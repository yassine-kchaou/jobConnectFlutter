import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobconnect/data/models/job_model.dart';
import 'package:jobconnect/domain/usecases/job_usecases.dart';

// Events
abstract class JobEvent extends Equatable {
  const JobEvent();
}

class FetchAllJobsEvent extends JobEvent {
  final int page;
  final int limit;

  const FetchAllJobsEvent({this.page = 1, this.limit = 10});

  @override
  List<Object> get props => [page, limit];
}

class FetchJobByIdEvent extends JobEvent {
  final String jobId;

  const FetchJobByIdEvent({required this.jobId});

  @override
  List<Object> get props => [jobId];
}

class FetchJobsByCityEvent extends JobEvent {
  final String city;

  const FetchJobsByCityEvent({required this.city});

  @override
  List<Object> get props => [city];
}

class FetchJobsByPriceAndTypeEvent extends JobEvent {
  final double minPrice;
  final double maxPrice;
  final String type;

  const FetchJobsByPriceAndTypeEvent({
    required this.minPrice,
    required this.maxPrice,
    required this.type,
  });

  @override
  List<Object> get props => [minPrice, maxPrice, type];
}

class CreateJobEvent extends JobEvent {
  final Map<String, dynamic> jobData;

  const CreateJobEvent({required this.jobData});

  @override
  List<Object> get props => [jobData];
}

class UpdateJobEvent extends JobEvent {
  final String jobId;
  final Map<String, dynamic> jobData;

  const UpdateJobEvent({
    required this.jobId,
    required this.jobData,
  });

  @override
  List<Object> get props => [jobId, jobData];
}

class DeleteJobEvent extends JobEvent {
  final String jobId;

  const DeleteJobEvent({required this.jobId});

  @override
  List<Object> get props => [jobId];
}

// States
abstract class JobState extends Equatable {
  const JobState();
}

class JobInitial extends JobState {
  const JobInitial();

  @override
  List<Object> get props => [];
}

class JobLoading extends JobState {
  const JobLoading();

  @override
  List<Object> get props => [];
}

class JobsLoaded extends JobState {
  final List<JobModel> jobs;

  const JobsLoaded({required this.jobs});

  @override
  List<Object> get props => [jobs];
}

class JobDetailLoaded extends JobState {
  final JobModel job;

  const JobDetailLoaded({required this.job});

  @override
  List<Object> get props => [job];
}

class JobCreated extends JobState {
  final JobModel job;
  final String message;

  const JobCreated(
      {required this.job, this.message = 'Offre créée avec succès'});

  @override
  List<Object> get props => [job, message];
}

class JobUpdated extends JobState {
  final JobModel job;
  final String message;

  const JobUpdated(
      {required this.job, this.message = 'Offre modifiée avec succès'});

  @override
  List<Object> get props => [job, message];
}

class JobDeleted extends JobState {
  final String message;

  const JobDeleted({this.message = 'Offre supprimée avec succès'});

  @override
  List<Object> get props => [message];
}

class JobFailure extends JobState {
  final String message;

  const JobFailure({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
class JobBloc extends Bloc<JobEvent, JobState> {
  final GetAllJobsUseCase getAllJobsUseCase;
  final GetJobByIdUseCase getJobByIdUseCase;
  final GetJobsByCityUseCase getJobsByCityUseCase;
  final GetJobsByPriceAndTypeUseCase getJobsByPriceAndTypeUseCase;
  final CreateJobUseCase createJobUseCase;
  final UpdateJobUseCase updateJobUseCase;
  final DeleteJobUseCase deleteJobUseCase;

  JobBloc({
    required this.getAllJobsUseCase,
    required this.getJobByIdUseCase,
    required this.getJobsByCityUseCase,
    required this.getJobsByPriceAndTypeUseCase,
    required this.createJobUseCase,
    required this.updateJobUseCase,
    required this.deleteJobUseCase,
  }) : super(const JobInitial()) {
    on<FetchAllJobsEvent>(_onFetchAllJobs);
    on<FetchJobByIdEvent>(_onFetchJobById);
    on<FetchJobsByCityEvent>(_onFetchJobsByCity);
    on<FetchJobsByPriceAndTypeEvent>(_onFetchJobsByPriceAndType);
    on<CreateJobEvent>(_onCreateJob);
    on<UpdateJobEvent>(_onUpdateJob);
    on<DeleteJobEvent>(_onDeleteJob);
  }

  Future<void> _onFetchAllJobs(
    FetchAllJobsEvent event,
    Emitter<JobState> emit,
  ) async {
    emit(const JobLoading());
    try {
      print('📋 [JobBloc] Fetching all jobs...');
      final result = await getAllJobsUseCase(
        page: event.page,
        limit: event.limit,
      );
      result.fold(
        (failure) {
          print('❌ [JobBloc] Failure: ${failure.message}');
          emit(JobFailure(message: failure.message));
        },
        (jobs) {
          print('✅ [JobBloc] Success: ${jobs.length} jobs loaded');
          // Convert Job entities to JobModels
          final jobModels = jobs.map((job) => job.toJobModel()).toList();
          emit(JobsLoaded(jobs: jobModels));
        },
      );
    } catch (e) {
      print('❌ [JobBloc] Exception: $e');
      emit(JobFailure(message: e.toString()));
    }
  }

  Future<void> _onFetchJobById(
    FetchJobByIdEvent event,
    Emitter<JobState> emit,
  ) async {
    emit(const JobLoading());
    final result = await getJobByIdUseCase(event.jobId);
    result.fold(
      (failure) => emit(JobFailure(message: failure.message)),
      (job) => emit(JobDetailLoaded(job: job.toJobModel())),
    );
  }

  Future<void> _onFetchJobsByCity(
    FetchJobsByCityEvent event,
    Emitter<JobState> emit,
  ) async {
    emit(const JobLoading());
    final result = await getJobsByCityUseCase(event.city);
    result.fold(
      (failure) => emit(JobFailure(message: failure.message)),
      (jobs) {
        final jobModels = jobs.map((job) => job.toJobModel()).toList();
        emit(JobsLoaded(jobs: jobModels));
      },
    );
  }

  Future<void> _onFetchJobsByPriceAndType(
    FetchJobsByPriceAndTypeEvent event,
    Emitter<JobState> emit,
  ) async {
    emit(const JobLoading());
    final result = await getJobsByPriceAndTypeUseCase(
      minPrice: event.minPrice,
      maxPrice: event.maxPrice,
      type: event.type,
    );
    result.fold(
      (failure) => emit(JobFailure(message: failure.message)),
      (jobs) {
        final jobModels = jobs.map((job) => job.toJobModel()).toList();
        emit(JobsLoaded(jobs: jobModels));
      },
    );
  }

  Future<void> _onCreateJob(
    CreateJobEvent event,
    Emitter<JobState> emit,
  ) async {
    emit(const JobLoading());
    try {
      print('📝 [JobBloc] Creating job with data: ${event.jobData}');
      final result = await createJobUseCase(event.jobData);
      result.fold(
        (failure) {
          print('❌ [JobBloc] Create job failed: ${failure.message}');
          emit(JobFailure(message: failure.message));
        },
        (job) {
          print('✅ [JobBloc] Job created successfully: ${job.id}');
          emit(JobCreated(
            job: job.toJobModel(),
            message: 'Offre d\'emploi créée avec succès',
          ));
        },
      );
    } catch (e) {
      print('❌ [JobBloc] Create job exception: $e');
      emit(JobFailure(message: 'Erreur lors de la création: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateJob(
    UpdateJobEvent event,
    Emitter<JobState> emit,
  ) async {
    emit(const JobLoading());
    try {
      print(
          '[JobBloc] Updating job ${event.jobId} with data: ${event.jobData}');
      final result = await updateJobUseCase(event.jobId, event.jobData);
      result.fold(
        (failure) {
          print('❌ [JobBloc] Update job failed: ${failure.message}');
          emit(JobFailure(message: failure.message));
        },
        (job) {
          print('✅ [JobBloc] Job updated successfully: ${job.id}');
          emit(JobUpdated(
            job: job.toJobModel(),
            message: 'Offre d\'emploi modifiée avec succès',
          ));
        },
      );
    } catch (e) {
      print('❌ [JobBloc] Update job exception: $e');
      emit(JobFailure(
          message: 'Erreur lors de la modification: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteJob(
    DeleteJobEvent event,
    Emitter<JobState> emit,
  ) async {
    emit(const JobLoading());
    try {
      print('[JobBloc] Deleting job ${event.jobId}');
      final result = await deleteJobUseCase(event.jobId);
      result.fold(
        (failure) {
          print('❌ [JobBloc] Delete job failed: ${failure.message}');
          emit(JobFailure(message: failure.message));
        },
        (_) {
          print('✅ [JobBloc] Job deleted successfully: ${event.jobId}');
          emit(const JobDeleted(
            message: 'Offre d\'emploi supprimée avec succès',
          ));
        },
      );
    } catch (e) {
      print('❌ [JobBloc] Delete job exception: $e');
      emit(JobFailure(
          message: 'Erreur lors de la suppression: ${e.toString()}'));
    }
  }
}
