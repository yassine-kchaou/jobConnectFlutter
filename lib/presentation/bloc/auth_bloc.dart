import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobconnect/core/config/api_client.dart';
import 'package:jobconnect/core/config/local_storage.dart';
import 'package:jobconnect/domain/entities/user_entity.dart';
import 'package:jobconnect/domain/usecases/auth_usecases.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthSignupEvent extends AuthEvent {
  final Map<String, dynamic> data; // Contient "user" et "resume"

  const AuthSignupEvent({required this.data});

  @override
  List<Object> get props => [data];
}

class AuthLogoutEvent extends AuthEvent {
  const AuthLogoutEvent();

  @override
  List<Object> get props => [];
}

class AuthCheckStatusEvent extends AuthEvent {
  const AuthCheckStatusEvent();

  @override
  List<Object> get props => [];
}

// States
abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {
  const AuthLoading();

  @override
  List<Object> get props => [];
}

class AuthSuccess extends AuthState {
  final User user;
  final String token;
  final String role;

  const AuthSuccess({
    required this.user,
    required this.token,
    required this.role,
  });

  @override
  List<Object> get props => [user, token, role];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();

  @override
  List<Object> get props => [];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final LocalStorage localStorage;

  AuthBloc({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.localStorage,
  }) : super(const AuthInitial()) {
    on<AuthLoginEvent>(_onLogin);
    on<AuthSignupEvent>(_onSignup);
    on<AuthLogoutEvent>(_onLogout);
    on<AuthCheckStatusEvent>(_onCheckStatus);
  }

  Future<void> _onLogin(AuthLoginEvent event, Emitter<AuthState> emit) async {
    print('[AuthBloc] Login event received: ${event.email}');
    emit(const AuthLoading());

    try {
      final result = await loginUseCase.call(event.email, event.password);
      await result.fold(
        (failure) async {
          print('[AuthBloc] Login failed: ${failure.message}');
          emit(AuthFailure(message: failure.message));
        },
        (authResponse) async {
          print(
              '[AuthBloc] Login successful for user: ${authResponse.user.email}');
          await localStorage.setToken(authResponse.token);
          ApiClient().setToken(authResponse.token);
          await localStorage.setUserId(authResponse.user.id);
          await localStorage.setUserRole(authResponse.user.role);
          await localStorage.setUserEmail(authResponse.user.email);
          await localStorage.setUserName(authResponse.user.name);
          print('[AuthBloc] Emitting AuthSuccess state');
          emit(
            AuthSuccess(
              user: authResponse.user,
              token: authResponse.token,
              role: authResponse.user.role,
            ),
          );
        },
      );
    } catch (e) {
      print('[AuthBloc] Unexpected error during login: $e');
      emit(AuthFailure(message: 'Erreur: ${e.toString()}'));
    }
  }

  Future<void> _onSignup(AuthSignupEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await signupUseCase.call(event.data); // Map complet

    // Utilisation de fold correctement
    await result.fold(
      (failure) async {
        emit(AuthFailure(message: failure.message));
      },
      (authResponse) async {
        await localStorage.setToken(authResponse.token);
        ApiClient().setToken(authResponse.token);
        await localStorage.setUserId(authResponse.user.id);
        await localStorage.setUserRole(authResponse.user.role);
        await localStorage.setUserEmail(authResponse.user.email);
        await localStorage.setUserName(authResponse.user.name);

        emit(
          AuthSuccess(
            user: authResponse.user,
            token: authResponse.token,
            role: authResponse.user.role,
          ),
        );
      },
    );
  }

  Future<void> _onLogout(AuthLogoutEvent event, Emitter<AuthState> emit) async {
    print('[AuthBloc] Logout event received');
    try {
      await localStorage.clearAll();
      print('[AuthBloc] Local storage cleared');
      emit(const AuthUnauthenticated());
      print('[AuthBloc] Emitted AuthUnauthenticated state');
    } catch (e) {
      print('[AuthBloc] Error during logout: $e');
    }
  }

  Future<void> _onCheckStatus(
    AuthCheckStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    final token = localStorage.getToken();
    if (token != null && token.isNotEmpty) {
      final userId = localStorage.getUserId();
      final role = localStorage.getUserRole();
      final email = localStorage.getUserEmail();
      final name = localStorage.getUserName();

      if (userId != null && role != null) {
        // ⚠️ CRITICAL: Set token in ApiClient when restoring from storage
        ApiClient().setToken(token);

        final user = User(
          id: userId,
          email: email ?? '',
          name: name ?? '',
          role: role,
        );
        emit(AuthSuccess(user: user, token: token, role: role));
      } else {
        emit(const AuthUnauthenticated());
      }
    } else {
      emit(const AuthUnauthenticated());
    }
  }
}
