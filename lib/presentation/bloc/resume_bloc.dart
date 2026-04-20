import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobconnect/domain/entities/resume_entity.dart';
import 'package:jobconnect/domain/usecases/resume_usecases.dart';

// Events
abstract class ResumeEvent extends Equatable {
  const ResumeEvent();
}

class FetchResumeByIdEvent extends ResumeEvent {
  final String resumeId;

  const FetchResumeByIdEvent({required this.resumeId});

  @override
  List<Object> get props => [resumeId];
}

class FetchResumesByUserIdEvent extends ResumeEvent {
  final String userId;

  const FetchResumesByUserIdEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class CreateResumeEvent extends ResumeEvent {
  final Map<String, dynamic> resumeData;

  const CreateResumeEvent({required this.resumeData});

  @override
  List<Object> get props => [resumeData];
}

class UpdateResumeEvent extends ResumeEvent {
  final String resumeId;
  final Map<String, dynamic> resumeData;

  const UpdateResumeEvent({
    required this.resumeId,
    required this.resumeData,
  });

  @override
  List<Object> get props => [resumeId, resumeData];
}

class DeleteResumeEvent extends ResumeEvent {
  final String resumeId;

  const DeleteResumeEvent({required this.resumeId});

  @override
  List<Object> get props => [resumeId];
}

class AddEducationEvent extends ResumeEvent {
  final String resumeId;
  final Map<String, dynamic> educationData;

  const AddEducationEvent({
    required this.resumeId,
    required this.educationData,
  });

  @override
  List<Object> get props => [resumeId, educationData];
}

class AddExperienceEvent extends ResumeEvent {
  final String resumeId;
  final Map<String, dynamic> experienceData;

  const AddExperienceEvent({
    required this.resumeId,
    required this.experienceData,
  });

  @override
  List<Object> get props => [resumeId, experienceData];
}

class AddSkillEvent extends ResumeEvent {
  final String resumeId;
  final String skillName;

  const AddSkillEvent({
    required this.resumeId,
    required this.skillName,
  });

  @override
  List<Object> get props => [resumeId, skillName];
}

class AddLanguageEvent extends ResumeEvent {
  final String resumeId;
  final Map<String, dynamic> languageData;

  const AddLanguageEvent({
    required this.resumeId,
    required this.languageData,
  });

  @override
  List<Object> get props => [resumeId, languageData];
}

class AddCertificationEvent extends ResumeEvent {
  final String resumeId;
  final Map<String, dynamic> certificationData;

  const AddCertificationEvent({
    required this.resumeId,
    required this.certificationData,
  });

  @override
  List<Object> get props => [resumeId, certificationData];
}

// States
abstract class ResumeState extends Equatable {
  const ResumeState();
}

class ResumeInitial extends ResumeState {
  const ResumeInitial();

  @override
  List<Object> get props => [];
}

class ResumeLoading extends ResumeState {
  const ResumeLoading();

  @override
  List<Object> get props => [];
}

class ResumeLoaded extends ResumeState {
  final Resume resume;

  const ResumeLoaded({required this.resume});

  @override
  List<Object> get props => [resume];
}

class ResumesLoaded extends ResumeState {
  final List<Resume> resumes;

  const ResumesLoaded({required this.resumes});

  @override
  List<Object> get props => [resumes];
}

class ResumeCreated extends ResumeState {
  final Resume resume;

  const ResumeCreated({required this.resume});

  @override
  List<Object> get props => [resume];
}

class ResumeUpdated extends ResumeState {
  final Resume resume;

  const ResumeUpdated({required this.resume});

  @override
  List<Object> get props => [resume];
}

class ResumeDeleted extends ResumeState {
  const ResumeDeleted();

  @override
  List<Object> get props => [];
}

class ResumeFailure extends ResumeState {
  final String message;

  const ResumeFailure({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
class ResumeBloc extends Bloc<ResumeEvent, ResumeState> {
  final GetResumeByIdUseCase getResumeByIdUseCase;
  final GetResumesByUserIdUseCase getResumesByUserIdUseCase;
  final CreateResumeUseCase createResumeUseCase;
  final UpdateResumeUseCase updateResumeUseCase;
  final DeleteResumeUseCase deleteResumeUseCase;
  final AddEducationUseCase addEducationUseCase;
  final AddExperienceUseCase addExperienceUseCase;
  final AddSkillUseCase addSkillUseCase;
  final AddLanguageUseCase addLanguageUseCase;
  final AddCertificationUseCase addCertificationUseCase;

  ResumeBloc({
    required this.getResumeByIdUseCase,
    required this.getResumesByUserIdUseCase,
    required this.createResumeUseCase,
    required this.updateResumeUseCase,
    required this.deleteResumeUseCase,
    required this.addEducationUseCase,
    required this.addExperienceUseCase,
    required this.addSkillUseCase,
    required this.addLanguageUseCase,
    required this.addCertificationUseCase,
  }) : super(const ResumeInitial()) {
    on<FetchResumeByIdEvent>(_onFetchResumeById);
    on<FetchResumesByUserIdEvent>(_onFetchResumesByUserId);
    on<CreateResumeEvent>(_onCreateResume);
    on<UpdateResumeEvent>(_onUpdateResume);
    on<DeleteResumeEvent>(_onDeleteResume);
    on<AddEducationEvent>(_onAddEducation);
    on<AddExperienceEvent>(_onAddExperience);
    on<AddSkillEvent>(_onAddSkill);
    on<AddLanguageEvent>(_onAddLanguage);
    on<AddCertificationEvent>(_onAddCertification);
  }

  Future<void> _onFetchResumeById(
    FetchResumeByIdEvent event,
    Emitter<ResumeState> emit,
  ) async {
    print('📄 [ResumeBloc] Fetching resume with ID: ${event.resumeId}');
    emit(const ResumeLoading());
    final result = await getResumeByIdUseCase(event.resumeId);
    result.fold(
      (failure) {
        print('❌ [ResumeBloc] Error fetching resume: ${failure.message}');
        emit(ResumeFailure(message: failure.message));
      },
      (resume) {
        print('✅ [ResumeBloc] Resume loaded successfully');
        print('   - Title: ${resume.title}');
        print('   - Education: ${resume.education?.length ?? 0} items');
        print('   - Experience: ${resume.workExperience?.length ?? 0} items');
        print('   - Skills: ${resume.skills?.length ?? 0} items');
        emit(ResumeLoaded(resume: resume));
      },
    );
  }

  Future<void> _onFetchResumesByUserId(
    FetchResumesByUserIdEvent event,
    Emitter<ResumeState> emit,
  ) async {
    emit(const ResumeLoading());
    print('📄 [ResumeBloc] Fetching resumes for user: ${event.userId}');
    final result = await getResumesByUserIdUseCase(event.userId);
    result.fold(
      (failure) {
        print('❌ [ResumeBloc] Error: ${failure.message}');
        emit(ResumeFailure(message: failure.message));
      },
      (resumes) {
        print('✅ [ResumeBloc] Loaded ${resumes.length} resumes');
        emit(ResumesLoaded(resumes: resumes));
      },
    );
  }

  Future<void> _onCreateResume(
    CreateResumeEvent event,
    Emitter<ResumeState> emit,
  ) async {
    emit(const ResumeLoading());
    print('📄 [ResumeBloc] Creating resume...');
    final result = await createResumeUseCase(event.resumeData);
    result.fold(
      (failure) {
        print('❌ [ResumeBloc] Creation failed: ${failure.message}');
        emit(ResumeFailure(message: failure.message));
      },
      (resume) {
        print('✅ [ResumeBloc] Resume created successfully');
        emit(ResumeCreated(resume: resume));
      },
    );
  }

  Future<void> _onUpdateResume(
    UpdateResumeEvent event,
    Emitter<ResumeState> emit,
  ) async {
    emit(const ResumeLoading());
    final result = await updateResumeUseCase(
      event.resumeId,
      event.resumeData,
    );
    result.fold(
      (failure) => emit(ResumeFailure(message: failure.message)),
      (resume) => emit(ResumeUpdated(resume: resume)),
    );
  }

  Future<void> _onDeleteResume(
    DeleteResumeEvent event,
    Emitter<ResumeState> emit,
  ) async {
    emit(const ResumeLoading());
    print('📄 [ResumeBloc] Deleting resume: ${event.resumeId}');
    final result = await deleteResumeUseCase(event.resumeId);
    result.fold(
      (failure) {
        print('❌ [ResumeBloc] Delete failed: ${failure.message}');
        emit(ResumeFailure(message: failure.message));
      },
      (_) {
        print('✅ [ResumeBloc] Resume deleted successfully');
        emit(const ResumeDeleted());
      },
    );
  }

  Future<void> _onAddEducation(
    AddEducationEvent event,
    Emitter<ResumeState> emit,
  ) async {
    emit(const ResumeLoading());
    final result = await addEducationUseCase(
      event.resumeId,
      event.educationData,
    );
    result.fold(
      (failure) => emit(ResumeFailure(message: failure.message)),
      (resume) => emit(ResumeUpdated(resume: resume)),
    );
  }

  Future<void> _onAddExperience(
    AddExperienceEvent event,
    Emitter<ResumeState> emit,
  ) async {
    emit(const ResumeLoading());
    final result = await addExperienceUseCase(
      event.resumeId,
      event.experienceData,
    );
    result.fold(
      (failure) => emit(ResumeFailure(message: failure.message)),
      (resume) => emit(ResumeUpdated(resume: resume)),
    );
  }

  Future<void> _onAddSkill(
    AddSkillEvent event,
    Emitter<ResumeState> emit,
  ) async {
    emit(const ResumeLoading());
    final result = await addSkillUseCase(
      event.resumeId,
      event.skillName,
    );
    result.fold(
      (failure) => emit(ResumeFailure(message: failure.message)),
      (resume) => emit(ResumeUpdated(resume: resume)),
    );
  }

  Future<void> _onAddLanguage(
    AddLanguageEvent event,
    Emitter<ResumeState> emit,
  ) async {
    emit(const ResumeLoading());
    final result = await addLanguageUseCase(
      event.resumeId,
      event.languageData,
    );
    result.fold(
      (failure) => emit(ResumeFailure(message: failure.message)),
      (resume) => emit(ResumeUpdated(resume: resume)),
    );
  }

  Future<void> _onAddCertification(
    AddCertificationEvent event,
    Emitter<ResumeState> emit,
  ) async {
    emit(const ResumeLoading());
    final result = await addCertificationUseCase(
      event.resumeId,
      event.certificationData,
    );
    result.fold(
      (failure) => emit(ResumeFailure(message: failure.message)),
      (resume) => emit(ResumeUpdated(resume: resume)),
    );
  }
}
